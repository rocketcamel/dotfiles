mod endpoints;
mod error;
mod rcon;

use std::env;

use actix_web::{App, HttpServer, web};
use kube::Client;

use crate::rcon::RconClient;

pub struct AppState {
    rcon: RconClient,
    kube: Client,
}

struct Env {
    rcon_password: String,
}

#[cfg(debug_assertions)]
fn load_env() -> Env {
    dotenvy::dotenv().ok();
    Env {
        rcon_password: env::var("RCON_PASSWORD")
            .expect("environment variable RCON_PASSWORD must be set"),
    }
}

#[cfg(not(debug_assertions))]
fn load_env() -> Env {
    Env {
        rcon_password: env::var("RCON_PASSWORD")
            .expect("environment variable RCON_PASSWORD must be set"),
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let env = load_env();

    // Initialize Kubernetes client
    // Uses in-cluster config when running in k3s, falls back to ~/.kube/config locally
    let kube_client = Client::try_default()
        .await
        .expect("failed to create Kubernetes client");

    let app_state = web::Data::new(AppState {
        rcon: RconClient::new(env.rcon_password),
        kube: kube_client,
    });

    HttpServer::new(move || {
        App::new()
            .app_data(app_state.clone())
            .route(
                "/",
                web::get()
                    .to(async || concat!(env!("CARGO_PKG_NAME"), "/", env!("CARGO_PKG_VERSION"))),
            )
            .service(
                web::scope("/api")
                    .route(
                        "/minecraft-server-stats",
                        web::get().to(endpoints::server_stats::get_server_stats),
                    )
                    // .route(
                    //     "/minecraft/{server}/world-size",
                    //     web::get().to(endpoints::kubernetes::get_world_size),
                    // )
                    .route(
                        "/minecraft/{server}/uptime",
                        web::get().to(endpoints::server_uptime::get_uptime),
                    ), // .route(
                       //     "/minecraft/{server}/restore",
                       //     web::post().to(endpoints::kubernetes::create_restore),
                       // ),
            )
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
