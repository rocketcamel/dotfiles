use actix_web::{HttpResponse, web};
use serde::{Deserialize, Serialize};

use crate::AppState;
use crate::error::Result;
use crate::kubernetes;

#[derive(Deserialize)]
pub struct RestoreRequest {
    pub backup_file: String,
}

#[derive(Serialize)]
pub struct RestoreResponse {
    pub server: String,
    pub job_name: String,
    pub backup_file: String,
    pub status: String,
}

/// POST /api/minecraft/{server}/restore
pub async fn create_restore(
    app_state: web::Data<AppState>,
    path: web::Path<ServerPath>,
    body: web::Json<RestoreRequest>,
) -> Result<HttpResponse> {
    let job_name =
        kubernetes::create_restore_job(&app_state.kube, &path.server, &body.backup_file).await?;

    Ok(HttpResponse::Created().json(RestoreResponse {
        server: path.server.clone(),
        job_name,
        backup_file: body.backup_file.clone(),
        status: "created".to_string(),
    }))
}
