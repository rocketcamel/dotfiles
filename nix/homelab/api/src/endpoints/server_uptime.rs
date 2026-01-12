use actix_web::{HttpResponse, web};
use k8s_openapi::api::core::v1::Pod;
use kube::{Api, Client, api::ListParams};

use crate::{
    AppState,
    endpoints::MINECRAFT_NAMESPACE,
    error::{Error, Result},
};

#[derive(serde::Serialize)]
pub(super) struct PodUptime {
    pub seconds: i64,
    pub started_at: String,
}

pub async fn get_uptime(
    app_state: web::Data<AppState>,
    path: web::Path<String>,
) -> Result<HttpResponse> {
    let server = path.into_inner();
    let uptime = get_pod_uptime(&app_state.kube, &server).await?;

    Ok(HttpResponse::Ok().json(uptime))
}

pub(super) async fn find_minecraft_pod(client: &Client, server_name: &str) -> Result<Pod> {
    let pods: Api<Pod> = Api::namespaced(client.clone(), MINECRAFT_NAMESPACE);

    let label_selector = format!("app=minecraft-{server_name}");
    let lp = ListParams::default().labels(&label_selector);

    let pod_list = pods.list(&lp).await?;

    pod_list
        .items
        .into_iter()
        .next()
        .ok_or_else(|| Error::PodNotFound(format!("minecraft-{server_name}")))
}

pub(super) async fn get_pod_uptime(client: &Client, server_name: &str) -> Result<PodUptime> {
    let pod = find_minecraft_pod(client, server_name).await?;

    let start_time = pod
        .status
        .and_then(|s| s.start_time)
        .ok_or_else(|| Error::PodExec("pod has no start time".into()))?;
    let now = chrono::Utc::now();
    let duration = now.signed_duration_since(&start_time.0);

    Ok(PodUptime {
        seconds: duration.num_seconds(),
        started_at: start_time.0.to_rfc3339(),
    })
}
