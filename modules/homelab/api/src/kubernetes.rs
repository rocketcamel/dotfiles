use futures::TryStreamExt;
use k8s_openapi::api::batch::v1::Job;
use k8s_openapi::api::core::v1::Pod;
use kube::Client;
use kube::api::{Api, AttachParams, ListParams, PostParams};

use crate::error::{Error, Result};

const NFS_SERVER: &str = "192.168.27.2";
const NFS_BACKUP_PATH: &str = "/backup/minecraft";

/// Find the Minecraft server pod by server name (e.g., "main", "creative")

/// Execute a command in a pod and return stdout
pub async fn exec_in_pod(client: &Client, pod_name: &str, command: Vec<&str>) -> Result<String> {
    let pods: Api<Pod> = Api::namespaced(client.clone(), MINECRAFT_NAMESPACE);

    let ap = AttachParams {
        stdout: true,
        stderr: true,
        ..Default::default()
    };

    let mut attached = pods.exec(pod_name, command, &ap).await?;

    let mut stdout_str = String::new();
    if let Some(stdout) = attached.stdout() {
        let bytes: Vec<u8> = tokio_util::io::ReaderStream::new(stdout)
            .try_collect::<Vec<_>>()
            .await
            .map_err(|e| Error::PodExec(e.to_string()))?
            .into_iter()
            .flatten()
            .collect();
        stdout_str = String::from_utf8_lossy(&bytes).to_string();
    }

    // Wait for exec to finish
    attached
        .join()
        .await
        .map_err(|e| Error::PodExec(e.to_string()))?;

    Ok(stdout_str.trim().to_string())
}

/// Get the world size by running du -sh /data in the pod
/// Get pod uptime by calculating time since pod started

/// Create a restore job for a Minecraft server
pub async fn create_restore_job(
    client: &Client,
    server_name: &str,
    backup_file: &str,
) -> Result<String> {
    let jobs: Api<Job> = Api::namespaced(client.clone(), MINECRAFT_NAMESPACE);

    let job = build_restore_job(server_name, backup_file);
    let job_name = job
        .metadata
        .name
        .clone()
        .unwrap_or_else(|| "unknown".into());

    jobs.create(&PostParams::default(), &job).await?;

    Ok(job_name)
}

fn build_restore_job(server_name: &str, backup_file: &str) -> Job {
    use k8s_openapi::api::core::v1::{
        Container, EnvVar, NFSVolumeSource, PersistentVolumeClaimVolumeSource, PodSecurityContext,
        PodSpec, PodTemplateSpec, Volume, VolumeMount,
    };

    let job_name = format!(
        "minecraft-restore-{server_name}-{}",
        chrono::Utc::now().timestamp()
    );

    let restore_script = r#"
set -e

echo "=========================================="
echo "Minecraft World Restore Job"
echo "=========================================="
echo ""

SERVER_NAME="${SERVER_NAME}"
BACKUP_FILE="${BACKUP_FILE:-latest.tgz}"
BACKUP_PATH="/backups/${BACKUP_FILE}"
DATA_DIR="/data"

echo "Configuration:"
echo "  Server: ${SERVER_NAME}"
echo "  Backup file: ${BACKUP_FILE}"
echo "  Backup path: ${BACKUP_PATH}"
echo "  Data directory: ${DATA_DIR}"
echo ""

if [ ! -f "${BACKUP_PATH}" ]; then
  echo "ERROR: Backup file not found: ${BACKUP_PATH}"
  echo ""
  echo "Available backups:"
  ls -lh /backups/ | grep "minecraft-${SERVER_NAME}" || echo "  (none found)"
  exit 1
fi

echo "Backup file found"
echo "  Size: $(du -hL ${BACKUP_PATH} | cut -f1)"
echo ""

if [ -d "${DATA_DIR}/world" ]; then
  echo "WARNING: Existing world data found!"
  echo "Removing existing world data..."
  rm -rf "${DATA_DIR}/world" "${DATA_DIR}/world_nether" "${DATA_DIR}/world_the_end"
  echo "Old world data removed"
fi
echo ""

echo "Extracting backup..."
tar -xzf "${BACKUP_PATH}" -C "${DATA_DIR}/"

echo ""
echo "=========================================="
echo "Restore Complete!"
echo "=========================================="
"#;

    Job {
        metadata: kube::core::ObjectMeta {
            name: Some(job_name),
            namespace: Some(MINECRAFT_NAMESPACE.to_string()),
            labels: Some(
                [("app".to_string(), "minecraft-restore".to_string())]
                    .into_iter()
                    .collect(),
            ),
            ..Default::default()
        },
        spec: Some(k8s_openapi::api::batch::v1::JobSpec {
            backoff_limit: Some(0),
            ttl_seconds_after_finished: Some(3600),
            template: PodTemplateSpec {
                metadata: Some(kube::core::ObjectMeta {
                    labels: Some(
                        [("app".to_string(), "minecraft-restore".to_string())]
                            .into_iter()
                            .collect(),
                    ),
                    ..Default::default()
                }),
                spec: Some(PodSpec {
                    restart_policy: Some("Never".to_string()),
                    security_context: Some(PodSecurityContext {
                        fs_group: Some(2000),
                        run_as_user: Some(1000),
                        run_as_group: Some(3000),
                        ..Default::default()
                    }),
                    containers: vec![Container {
                        name: "restore".to_string(),
                        image: Some("busybox:latest".to_string()),
                        command: Some(vec!["sh".to_string(), "-c".to_string()]),
                        args: Some(vec![restore_script.to_string()]),
                        env: Some(vec![
                            EnvVar {
                                name: "SERVER_NAME".to_string(),
                                value: Some(server_name.to_string()),
                                ..Default::default()
                            },
                            EnvVar {
                                name: "BACKUP_FILE".to_string(),
                                value: Some(backup_file.to_string()),
                                ..Default::default()
                            },
                        ]),
                        volume_mounts: Some(vec![
                            VolumeMount {
                                name: "data".to_string(),
                                mount_path: "/data".to_string(),
                                ..Default::default()
                            },
                            VolumeMount {
                                name: "backups".to_string(),
                                mount_path: "/backups".to_string(),
                                read_only: Some(true),
                                ..Default::default()
                            },
                        ]),
                        ..Default::default()
                    }],
                    volumes: Some(vec![
                        Volume {
                            name: "data".to_string(),
                            persistent_volume_claim: Some(PersistentVolumeClaimVolumeSource {
                                claim_name: format!("minecraft-{server_name}-datadir"),
                                ..Default::default()
                            }),
                            ..Default::default()
                        },
                        Volume {
                            name: "backups".to_string(),
                            nfs: Some(NFSVolumeSource {
                                server: NFS_SERVER.to_string(),
                                path: NFS_BACKUP_PATH.to_string(),
                                ..Default::default()
                            }),
                            ..Default::default()
                        },
                    ]),
                    ..Default::default()
                }),
            },
            ..Default::default()
        }),
        ..Default::default()
    }
}
