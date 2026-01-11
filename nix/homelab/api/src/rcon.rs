use nom::{
    IResult, Parser, bytes::complete::tag, character::complete::digit1, combinator::map_res,
    sequence::preceded,
};
use rcon::Connection;
use tokio::{net::TcpStream, sync::Mutex};

use crate::error::Result;

fn parse_u16(input: &str) -> IResult<&str, u16> {
    map_res(digit1, |s: &str| s.parse::<u16>()).parse(input)
}

pub fn parse_online_list(input: &str) -> IResult<&str, (u16, u16)> {
    let (remaining, (online, max)) = (
        preceded(tag("There are "), parse_u16),
        preceded(tag(" of a max of "), parse_u16),
    )
        .parse(input)?;
    Ok((remaining, (online, max)))
}

pub struct RconClient {
    connection: Mutex<Option<Connection<TcpStream>>>,
    rcon_password: String,
}

impl RconClient {
    pub fn new(rcon_password: String) -> Self {
        Self {
            connection: None.into(),
            rcon_password,
        }
    }

    pub async fn cmd(&self, command: &str) -> Result<String> {
        let mut connection = self.connection.lock().await;

        if connection.is_none() {
            let conn = create_connection(&self.rcon_password).await?;
            *connection = Some(conn)
        }

        Ok(connection.as_mut().unwrap().cmd(command).await?)
    }
}

async fn create_connection(rcon_password: &str) -> Result<Connection<TcpStream>> {
    Ok(Connection::<TcpStream>::builder()
        .enable_minecraft_quirks(true)
        .connect("192.168.27.12:25575", rcon_password)
        .await?)
}
