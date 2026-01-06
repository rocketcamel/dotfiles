mod commands;
mod dns;
mod error;
mod lease_parser;
mod pihole;
mod transport;

use std::path::{Path, PathBuf};
use std::{collections::HashSet, env};

use anyhow::Context;
use clap::{CommandFactory, Parser};
use serde::{Deserialize, Serialize};
use thiserror::Error;

use crate::{
    commands::{
        Commands,
        generate_routes::{Route, generate_routes},
    },
    dns::Router,
    lease_parser::{BindingState, Lease},
    pihole::PiHoleClient,
    transport::SSHTransport,
};

#[derive(Parser, Debug)]
#[command(version = "0.1.0", about = "Helper for k3s", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Debug, Error)]
pub enum HelperError {
    #[error("error reading file")]
    ReadFile(#[from] std::io::Error),
    #[error("error parsing config toml")]
    TomlError(#[from] toml::de::Error),
    #[error("entrypoint required for tcproute: {0:?}")]
    TCPEntryPoint(String),
}

#[derive(Serialize, Deserialize)]
pub struct Config {
    routes: Vec<Route>,
    pihole: Option<PiHoleConfig>,
    router: Option<RouterConfig>,
}

#[derive(Serialize, Deserialize)]
pub struct PiHoleConfig {
    url: String,
    password_file: String,
    extra_hosts: Option<HashSet<String>>,
}

#[derive(Serialize, Deserialize)]
pub struct RouterConfig {
    host: String,
    user: String,
    key_path: PathBuf,
    lease_file: String,
}

pub fn parse_config<T: AsRef<Path>>(path: T) -> anyhow::Result<Config> {
    let bytes = std::fs::read(&path).context(format!(
        "failed to read config file: {}",
        path.as_ref().display()
    ))?;
    Ok(toml::from_slice::<Config>(&bytes)?)
}

fn env_or<S: Into<String>>(key: &str, fallback: S) -> String {
    env::var(key).unwrap_or_else(|_| fallback.into())
}

#[tokio::main(flavor = "current_thread")]
async fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();

    match &cli.command {
        Some(Commands::GenerateRoutes {}) => {
            let config = parse_config("./config.toml")?;
            generate_routes(&config)?;
        }
        Some(Commands::SyncDNS {}) => {
            let config_path = env_or("CONFIG_PATH", "./config.toml");
            let config = parse_config(config_path)?;
            let pihole_config = config
                .pihole
                .context("pihole configuration is necessary for syncing dns")?;
            let router_config = config
                .router
                .context("router configuration is necessary for syncing dns")?;

            let password = std::fs::read_to_string(&pihole_config.password_file)
                .context(format!(
                    "failed to read pihole password from {}",
                    pihole_config.password_file
                ))?
                .trim()
                .to_string();

            let leases = tokio::task::spawn_blocking(move || -> anyhow::Result<Vec<Lease>> {
                let r = Router::new(SSHTransport::new(
                    &router_config.host,
                    &router_config.user,
                    &router_config.key_path,
                )?);
                let leases = r
                    .dhcp_leases(&router_config.lease_file)?
                    .into_iter()
                    .filter(|l| {
                        l.binding_state == BindingState::Active && l.client_hostname.is_some()
                    })
                    .collect();
                Ok(leases)
            })
            .await??;

            let mut desired = leases
                .into_iter()
                .map(|l| {
                    format!(
                        "{} {}",
                        l.ip,
                        l.client_hostname.expect("filtered for Some above")
                    )
                })
                .collect::<HashSet<String>>();
            if let Some(extra_hosts) = pihole_config.extra_hosts {
                desired.extend(extra_hosts);
            }

            println!("Found {} active leases with hostnames", desired.len());

            let client = PiHoleClient::new(&pihole_config.url, &password).await?;

            let stats = client.sync_hosts(desired).await?;
            println!(
                "Sync complete: added {}, removed {}",
                stats.added, stats.removed
            );
        }
        None => Cli::command().print_long_help()?,
    }

    Ok(())
}
