use crate::{
    error::Result,
    lease_parser::{Lease, parse_leases},
    transport::Transport,
};

pub struct Router<T: Transport> {
    transport: T,
}

impl<T: Transport> Router<T> {
    pub fn new(transport: T) -> Self {
        Self { transport }
    }

    pub fn dhcp_leases(&self, resource: &str) -> Result<Vec<Lease>> {
        let raw = self.transport.fetch(resource)?;
        parse_leases(&raw).map_err(|e| crate::error::Error::Parse(e.to_string()))
    }
}
