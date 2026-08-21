use thiserror::Error;

#[derive(Debug, Error)]
pub enum Error {
    #[error("SSH error: {0}")]
    SSH(#[from] ssh2::Error),
    #[error("parse error: {0}")]
    Parse(String),
    #[error("IO error: {0}")]
    IO(#[from] std::io::Error),
    #[error("command return non 0 exit code: {0}")]
    ExitCode(i32),
    #[error("HTTP error: {0}")]
    Http(#[from] reqwest::Error),
    #[error("Pi-hole API error: {0}")]
    PiHole(String),
    #[cfg(not(feature = "file-config"))]
    #[error("missing environment variables: {0}")]
    MissingEnvVars(String),
    #[cfg(feature = "file-config")]
    #[error("error parsing toml: {0}")]
    TomlParse(#[from] toml::de::Error),
}

pub type Result<T> = std::result::Result<T, Error>;
