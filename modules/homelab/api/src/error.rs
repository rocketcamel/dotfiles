use actix_web::{HttpResponse, ResponseError, body::BoxBody, http::StatusCode};
use thiserror::Error;

pub type Result<T> = core::result::Result<T, Error>;

#[derive(Debug, Error)]
pub enum Error {
    #[error("rcon error: {0}")]
    Rcon(#[from] rcon::Error),
    #[error("parse error: {0}")]
    Parse(String),
    #[error("kubernetes error: {0}")]
    Kube(#[from] kube::Error),
    #[error("pod not found: {0}")]
    PodNotFound(String),
    #[error("pod exec error: {0}")]
    PodExec(String),
}

impl ResponseError for Error {
    fn status_code(&self) -> StatusCode {
        match self {
            Self::Rcon(_) => StatusCode::SERVICE_UNAVAILABLE,
            Self::PodNotFound(_) => StatusCode::NOT_FOUND,
            Self::Kube(_) | Self::PodExec(_) => StatusCode::BAD_GATEWAY,
            _ => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }

    fn error_response(&self) -> HttpResponse<BoxBody> {
        HttpResponse::build(self.status_code()).body(self.to_string())
    }
}
