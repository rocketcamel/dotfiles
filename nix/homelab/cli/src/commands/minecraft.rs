use askama::Template;
use clap::{Args, Subcommand};
use futures::{AsyncBufReadExt, StreamExt, TryStreamExt};
use k8s_openapi::api::apps::v1::Deployment;
use k8s_openapi::api::batch::v1::Job;
use k8s_openapi::api::core::v1::Pod;
use kube::api::{Api, LogParams, Patch, PatchParams, PostParams};
use kube::runtime::{WatchStreamExt, watcher};
use serde_json::json;

use crate::State;
use crate::error::{ErrorKind, Result};
use crate::reporter::Reporter;

const NAMESPACE: &str = "minecraft";

#[derive(Debug, Args)]
pub struct MinecraftCommand {
    #[command(subcommand)]
    command: MinecraftSubcommand,
}

#[derive(Debug, Subcommand)]
enum MinecraftSubcommand {
    /// Backup a minecraft world
    Backup {
        /// the world to backup
        #[arg(short, long)]
        world: String,
    },
}

#[derive(Template)]
#[template(path = "backup-job.yaml")]
struct BackupJobTemplate<'a> {
    world: &'a str,
}

impl MinecraftCommand {
    pub async fn run(&self, state: State) -> Result<()> {
        match &self.command {
            MinecraftSubcommand::Backup { world } => backup_world(state, world).await,
        }
    }
}

pub async fn backup_world(state: State, world: &str) -> Result<()> {
    let reporter = Reporter::new();
    let job_name = format!("minecraft-{}-backup", world);

    reporter.status(format!("Scaling deployment minecraft-{world}"));
    scale_deployment(&state.client, NAMESPACE, &format!("minecraft-{world}"), 0).await?;

    reporter.status("Creating backup job...");

    let job = build_backup_job(world)?;
    let jobs: Api<Job> = Api::namespaced(state.client.clone(), NAMESPACE);
    jobs.create(&PostParams::default(), &job).await?;

    reporter.status("Waiting for pod to start...");

    let pods: Api<Pod> = Api::namespaced(state.client.clone(), NAMESPACE);
    let pod_name = wait_for_job_pod(&pods, &job_name).await?;

    reporter.status("Running backup...");

    stream_pod_logs(&pods, &pod_name, &reporter).await?;

    let job = jobs.get(&job_name).await?;
    let status = job.status.as_ref();
    let succeeded = status.and_then(|s| s.succeeded).unwrap_or(0);
    let failed = status.and_then(|s| s.failed).unwrap_or(0);

    reporter.status(format!("Scaling deployment minecraft-{world}, replicas: 1"));
    scale_deployment(&state.client, NAMESPACE, &format!("minecraft-{world}"), 1).await?;
    if succeeded > 0 {
        reporter.success("Backup complete");
        Ok(())
    } else if failed > 0 {
        reporter.fail("Backup job failed");
        Err(ErrorKind::BackupFailed("Job failed".to_string()).into())
    } else {
        reporter.fail("Backup job status unknown");
        Err(ErrorKind::BackupFailed("Unknown status".to_string()).into())
    }
}

async fn scale_deployment(
    client: &kube::Client,
    namespace: &str,
    name: &str,
    replicas: i32,
) -> Result<()> {
    let deployments: Api<Deployment> = Api::namespaced(client.clone(), namespace);
    let patch = json!({ "spec": { "replicas": replicas } });
    deployments
        .patch(name, &PatchParams::default(), &Patch::Merge(&patch))
        .await?;
    Ok(())
}

async fn wait_for_job_pod(pods: &Api<Pod>, job_name: &str) -> Result<String> {
    let label_selector = format!("job-name={}", job_name);
    let config = watcher::Config::default().labels(&label_selector);

    let mut stream = watcher(pods.clone(), config).applied_objects().boxed();

    while let Some(pod) = stream.try_next().await? {
        let name = pod.metadata.name.as_deref().unwrap_or_default();
        let phase = pod
            .status
            .as_ref()
            .and_then(|s| s.phase.as_deref())
            .unwrap_or_default();

        if phase == "Running" || phase == "Succeeded" || phase == "Failed" {
            return Ok(name.to_string());
        }
    }

    Err(ErrorKind::BackupFailed("Pod never started".to_string()).into())
}

fn build_backup_job(world: &str) -> Result<Job> {
    let template = BackupJobTemplate { world };
    let yaml = template.render()?;
    Ok(serde_yaml::from_str(&yaml)?)
}

async fn stream_pod_logs(pods: &Api<Pod>, pod_name: &str, reporter: &Reporter) -> Result<()> {
    let params = LogParams {
        follow: true,
        ..Default::default()
    };

    let stream = pods.log_stream(pod_name, &params).await?;
    let mut lines = stream.lines();

    while let Some(line) = lines.try_next().await? {
        reporter.log(&line);
    }

    Ok(())
}
