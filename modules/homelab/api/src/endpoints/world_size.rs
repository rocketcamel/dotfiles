use actix_web::{HttpResponse, web};
use k8s_openapi::api::core::v1::Pod;
use kube::{Api, Client};
use serde::Serialize;

use crate::{
    AppState,
    endpoints::{MINECRAFT_NAMESPACE, server_uptime::find_minecraft_pod},
    error::{Error, Result},
};

#[derive(Serialize)]
pub struct WorldSizeResponse {
    pub server: String,
    pub size: String,
}

pub async fn get_world_size(
    app_state: web::Data<AppState>,
    path: web::Path<String>,
) -> Result<HttpResponse> {
    let server = path.into_inner();
    let size = get_size_inner(&app_state.kube, &server).await?;

    Ok(HttpResponse::Ok().json(WorldSizeResponse {
        server: server.clone(),
        size,
    }))
}

pub async fn get_size_inner(client: &Client, server_name: &str) -> Result<String> {
    let pod = find_minecraft_pod(client, server_name).await?;
    let pod_name = pod
        .metadata
        .name
        .ok_or_else(|| Error::PodNotFound("no pod name".into()))?;

    let output = exec_in_pod(client, &pod_name, vec!["du", "-sh", "/data"]).await?;

    let size = output
        .split_whitespace()
        .next()
        .unwrap_or("unknown")
        .to_string();

    Ok(size)
}

async fn exec_in_pod(client: &Client, pod_name: &str, command: &str) {
    let pods: Api<Pod> = Api::namespaced(client.clone(), MINECRAFT_NAMESPACE);
    
    const params = AttachParams {
        stdin: true,
        ..Default::default()
    };
}
