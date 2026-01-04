use std::collections::HashSet;

use reqwest::Client;
use serde::{Deserialize, Serialize};

use crate::error::{Error, Result};

pub struct PiHoleClient {
    client: Client,
    base_url: String,
    sid: String,
}

#[derive(Debug)]
pub struct SyncStats {
    pub added: usize,
    pub removed: usize,
}

#[derive(Debug, Deserialize)]
struct AuthResponse {
    session: Session,
    error: Option<AuthError>,
}

#[derive(Debug, Deserialize)]
struct Session {
    valid: bool,
    sid: Option<String>,
}

#[derive(Debug, Deserialize)]
struct AuthError {
    message: String,
}

#[derive(Debug, Serialize)]
struct AuthRequest {
    password: String,
}

#[derive(Debug, Deserialize)]
struct ConfigResponse {
    config: DnsConfig,
}

#[derive(Debug, Deserialize)]
struct DnsConfig {
    dns: DnsHosts,
}

#[derive(Debug, Deserialize)]
struct DnsHosts {
    hosts: Vec<String>,
}

impl PiHoleClient {
    pub async fn new(base_url: &str, password: &str) -> Result<Self> {
        let client = Client::new();
        let url = format!("{}/api/auth", base_url.trim_end_matches('/'));

        let response = client
            .post(&url)
            .json(&AuthRequest {
                password: password.to_string(),
            })
            .send()
            .await?;

        let auth: AuthResponse = response.json().await?;

        if !auth.session.valid {
            return Err(Error::PiHole(format!(
                "authentication failed: {}",
                auth.error.unwrap().message
            )));
        }

        let sid = auth.session.sid.ok_or_else(|| {
            Error::PiHole("authentication succeeded but no session ID returned".to_string())
        })?;

        Ok(Self {
            client,
            base_url: base_url.trim_end_matches('/').to_string(),
            sid,
        })
    }

    pub async fn get_hosts(&self) -> Result<HashSet<String>> {
        let url = format!("{}/api/config/dns/hosts", self.base_url);

        let response = self
            .client
            .get(&url)
            .header("X-FTL-SID", &self.sid)
            .send()
            .await?;

        if let Err(e) = response.error_for_status_ref() {
            return Err(Error::PiHole(format!("failed to get hosts: {}", e)));
        }

        let config: ConfigResponse = response.json().await?;
        Ok(config.config.dns.hosts.into_iter().collect())
    }

    pub async fn add_host(&self, entry: &str) -> Result<()> {
        let encoded = urlencoding::encode(entry);
        let url = format!("{}/api/config/dns/hosts/{}", self.base_url, encoded);

        let response = self
            .client
            .put(&url)
            .header("X-FTL-SID", &self.sid)
            .send()
            .await?;

        if let Err(e) = response.error_for_status_ref() {
            let body = response.text().await.unwrap_or_default();
            return Err(Error::PiHole(format!(
                "failed to add host '{}': {} - {}",
                entry, e, body
            )));
        }

        Ok(())
    }

    pub async fn delete_host(&self, entry: &str) -> Result<()> {
        let encoded = urlencoding::encode(entry);
        let url = format!("{}/api/config/dns/hosts/{}", self.base_url, encoded);

        let response = self
            .client
            .delete(&url)
            .header("X-FTL-SID", &self.sid)
            .send()
            .await?;

        if let Err(e) = response.error_for_status_ref() {
            let body = response.text().await.unwrap_or_default();
            return Err(Error::PiHole(format!(
                "failed to delete host '{}': {} - {}",
                entry, e, body
            )));
        }

        Ok(())
    }

    pub async fn sync_hosts(&self, desired: HashSet<String>) -> Result<SyncStats> {
        let current = self.get_hosts().await?;

        let to_delete = current.difference(&desired).cloned().collect::<Vec<_>>();
        let to_add = desired.difference(&current).cloned().collect::<Vec<_>>();

        for entry in &to_delete {
            self.delete_host(entry).await?;
        }

        for entry in &to_add {
            self.add_host(entry).await?;
        }

        Ok(SyncStats {
            added: to_add.len(),
            removed: to_delete.len(),
        })
    }
}
