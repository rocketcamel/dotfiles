mod commands;

use std::path::Path;

use anyhow::Context;
use clap::{CommandFactory, Parser};
use serde::{Deserialize, Serialize};
use thiserror::Error;

use crate::commands::{
    Commands,
    generate_routes::{Route, generate_routes},
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
}

pub fn parse_config<T: AsRef<Path>>(path: T) -> anyhow::Result<Config> {
    let bytes = std::fs::read(&path).context(format!(
        "failed to read config file: {}",
        path.as_ref().display()
    ))?;
    Ok(toml::from_slice::<Config>(&bytes)?)
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();

    match &cli.command {
        Some(Commands::GenerateRoutes {}) => {
            let config = parse_config("./config.toml")?;
            generate_routes(&config)?;
        }
        None => Cli::command().print_long_help()?,
    }

    Ok(())
}
