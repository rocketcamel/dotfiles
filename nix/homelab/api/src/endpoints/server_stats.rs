use actix_web::{HttpResponse, web};
use serde::Serialize;

use crate::{AppState, error::Result, rcon::parse_online_list};

#[derive(Serialize)]
pub struct ServerStats {
    pub status: String,
    pub players_online: u16,
    pub max_players: u16,
    pub uptime: Option<String>,
    pub world_size: Option<String>,
}

pub async fn get_server_stats(app_state: web::Data<AppState>) -> Result<HttpResponse> {
    let list_response = app_state.rcon.cmd("list").await?;

    let (_, (players_online, max_players)) =
        parse_online_list(&list_response).map_err(|e| crate::error::Error::Parse(e.to_string()))?;

    let stats = ServerStats {
        status: "Online".to_string(),
        players_online,
        max_players,
        uptime: None,
        world_size: None,
    };

    Ok(HttpResponse::Ok().json(stats))
}
