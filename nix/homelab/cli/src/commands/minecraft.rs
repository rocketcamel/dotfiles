use clap::{Args, Subcommand};
use kube::Api;

use crate::{AppState, State};

#[derive(Debug, Args)]
pub struct MinecraftCommand {
    #[command(subcommand)]
    command: MinecraftSubcommand,
}

#[derive(Debug, Subcommand)]
enum MinecraftSubcommand {
    Backup {
        /// the world to backup
        #[arg(short, long)]
        world: String,
    },
}

impl MinecraftCommand {
    pub async fn run(&self, app_state: State) {
        match &self.command {
            MinecraftSubcommand::Backup { world } => backup_world(app_state, &world),
        }
    }
}

pub fn backup_world(app_state: State, world: &str) {}
