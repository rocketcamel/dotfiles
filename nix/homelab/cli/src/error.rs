use thiserror::Error;

#[derive(Error, Debug, thiserror_ext::Box)]
#[thiserror_ext(newtype(name = Error))]
pub enum ErrorKind {
    #[error("kube error: {0}")]
    Kube(#[from] kube::Error),
}

pub type Result<T> = core::result::Result<T, Error>;
