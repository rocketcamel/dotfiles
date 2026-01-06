use std::{io::Read, net::TcpStream, path::Path};

use ssh2::Session;

use crate::{error::Result, transport::Transport};

pub struct SSHTransport {
    session: Session,
}

impl SSHTransport {
    pub fn new(host: &str, user: &str, key_path: &Path) -> Result<Self> {
        let stream = TcpStream::connect(host)?;

        let mut s = Self {
            session: Session::new()?,
        };
        s.session.set_tcp_stream(stream);
        s.session.handshake()?;
        s.session.userauth_pubkey_file(user, None, key_path, None)?;
        Ok(s)
    }
}

impl Transport for SSHTransport {
    fn fetch(&self, resource: &str) -> Result<String> {
        let mut channel = self.session.channel_session()?;
        channel.exec(&format!("cat {}", resource))?;

        let mut output = String::new();
        channel.read_to_string(&mut output)?;
        channel.wait_close()?;

        let c = channel.exit_status()?;
        if c != 0 {
            return Err(crate::error::Error::ExitCode(c));
        }

        Ok(output)
    }
}
