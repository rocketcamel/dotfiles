#[cfg(not(feature = "file-config"))]
use std::{collections::HashSet, env};

use serde::{Deserialize, Serialize};

use crate::{PiHoleConfig, RouterConfig, commands::generate_routes::Route, error::Result};

#[derive(Serialize, Deserialize)]
pub struct Config {
    pub routes: Option<Vec<Route>>,
    pub pihole: Option<PiHoleConfig>,
    pub router: Option<RouterConfig>,
}

#[cfg(not(feature = "file-config"))]
struct EnvCollector {
    missing: Vec<&'static str>,
}

#[cfg(not(feature = "file-config"))]
impl EnvCollector {
    fn new() -> Self {
        Self {
            missing: Vec::new(),
        }
    }

    fn get(&mut self, key: &'static str) -> Option<String> {
        match env::var(key) {
            Ok(val) => Some(val),
            Err(_) => {
                self.missing.push(key);
                None
            }
        }
    }

    fn finish(self) -> Result<()> {
        if self.missing.is_empty() {
            Ok(())
        } else {
            Err(crate::error::Error::MissingEnvVars(self.missing.join(", ")))
        }
    }
}

#[cfg(not(feature = "file-config"))]
pub fn parse_config() -> Result<Config> {
    let mut env = EnvCollector::new();

    let pihole_url = env.get("PIHOLE_URL");
    let pihole_password = env.get("PIHOLE_PASSWORD_FILE");
    let pihole_hosts = env.get("PIHOLE_EXTRA_HOSTS");
    let router_host = env.get("ROUTER_HOST");
    let router_user = env.get("ROUTER_USER");
    let router_key = env.get("ROUTER_KEY_PATH");
    let router_lease = env.get("ROUTER_LEASE_FILE");

    env.finish()?;

    Ok(Config {
        routes: None,
        pihole: Some(PiHoleConfig {
            url: pihole_url.unwrap(),
            password_file: pihole_password.unwrap(),
            extra_hosts: Some(
                pihole_hosts
                    .unwrap()
                    .split('\n')
                    .map(String::from)
                    .collect::<HashSet<String>>(),
            ),
        }),
        router: Some(RouterConfig {
            host: router_host.unwrap(),
            user: router_user.unwrap(),
            key_path: router_key.unwrap().into(),
            lease_file: router_lease.unwrap(),
        }),
    })
}

#[cfg(feature = "file-config")]
pub fn parse_config() -> Result<Config> {
    let bytes = std::fs::read("./config.toml")?;
    Ok(toml::from_slice::<Config>(&bytes)?)
}
