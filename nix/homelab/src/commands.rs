pub mod generate_routes;

use clap::Subcommand;

#[derive(Subcommand, Debug)]
pub enum Commands {
    /// generate gateway api routes
    GenerateRoutes,
}
