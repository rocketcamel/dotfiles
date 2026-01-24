use clap::Subcommand;
mod minecraft;

#[derive(Subcommand, Debug)]
pub enum Commands {
    /// minecraft management
    Minecraft(minecraft::MinecraftCommand),
}
