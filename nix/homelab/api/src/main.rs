mod endpoints;
mod error;
mod rcon;

use std::env;

use actix_web::{App, HttpServer, web};

use crate::rcon::RconClient;

struct AppState {
    rcon: RconClient,
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
    let app_state = web::Data::new(AppState {
        rcon: RconClient::new(env.rcon_password),
    });

    HttpServer::new(move || {
        App::new()
            .app_data(app_state.clone())
            .route(
                "/",
                web::get()
                    .to(async || concat!(env!("CARGO_PKG_NAME"), "/", env!("CARGO_PKG_VERSION"))),
            )
            .service(web::scope("/api").route(
                "/minecraft-server-stats",
                web::get().to(endpoints::server_stats::get_server_stats),
            ))
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}
