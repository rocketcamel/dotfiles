mod commands;
mod error;

use std::{ops::Deref, sync::Arc};

use clap::{CommandFactory, Parser};

use crate::{commands::Commands, error::Result};

#[derive(Parser, Debug)]
#[command(version, long_about = "homelab cli")]
struct Cli {
    #[command(subcommand)]
    command: Option<Commands>,
}

struct AppState {
    client: kube::Client,
}

#[derive(Clone)]
struct State(Arc<AppState>);

impl State {
    pub fn new(inner: AppState) -> Self {
        Self(Arc::new(inner))
    }
}

impl Deref for State {
    type Target = AppState;
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl AppState {
    pub async fn new() -> Result<Self> {
        Ok(Self {
            client: kube::Client::try_default().await?,
        })
    }
}

#[tokio::main(flavor = "current_thread")]
async fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    let app_state = State::new(AppState::new().await?);

    match cli.command {
        Some(Commands::Minecraft(cmd)) => cmd.run(app_state.clone()).await,
        _ => Cli::command().print_long_help()?,
    };

    Ok(())
}
