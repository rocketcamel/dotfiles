mod ssh;

pub use ssh::SSHTransport;

use crate::error::Result;

pub trait Transport {
    fn fetch(&self, resource: &str) -> Result<String>;
}
