use thiserror::Error;

#[derive(Error, Debug, thiserror_ext::Box)]
#[thiserror_ext(newtype(name = Error))]
pub enum ErrorKind {
    #[error("kube error: {0}")]
    Kube(#[from] kube::Error),
    #[error("watcher error: {0}")]
    Watcher(#[from] kube::runtime::watcher::Error),
    #[error("io error: {0}")]
    Io(#[from] std::io::Error),
    #[error("backup failed: {0}")]
    BackupFailed(String),
    #[error("template error: {0}")]
    Template(#[from] askama::Error),
    #[error("error deserializing yaml: {0}")]
    Yaml(#[from] serde_yaml::Error),
}

pub type Result<T> = core::result::Result<T, Error>;
