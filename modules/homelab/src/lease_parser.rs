use std::net::IpAddr;

use nom::{
    IResult, Parser,
    branch::alt,
    bytes::complete::{tag, take_till, take_until, take_while1},
    character::complete::{char, digit1, multispace1, space0, space1},
    combinator::{map, map_res, value},
    multi::many0,
    sequence::{delimited, preceded, terminated},
};

#[derive(Debug, Clone, PartialEq)]
pub struct Lease {
    pub ip: IpAddr,
    pub binding_state: BindingState,
    pub client_hostname: Option<String>,
}

#[allow(dead_code)]
#[derive(Debug, Clone, PartialEq)]
pub enum BindingState {
    Active,
    Free,
    Abandoned,
    Backup,
}

#[allow(dead_code)]
#[derive(Debug, Clone)]
enum LeaseField {
    BindingState(BindingState),
    ClientHostname(String),
    Other,
}

fn ws(input: &str) -> IResult<&str, ()> {
    value(
        (),
        many0(alt((
            value((), multispace1),
            value((), (tag("#"), take_until("\n"), tag("\n"))),
        ))),
    )
    .parse(input)
}

fn parse_ip(input: &str) -> IResult<&str, IpAddr> {
    map_res(
        take_while1(|c: char| c.is_ascii_digit() || c == '.'),
        str::parse,
    )
    .parse(input)
}

fn parse_field(input: &str) -> IResult<&str, LeaseField> {
    alt((
        map(
            preceded(
                (tag("client-hostname"), space1),
                terminated(
                    delimited(char('"'), take_until("\""), char('"')),
                    (space0, char(';')),
                ),
            ),
            |h: &str| LeaseField::ClientHostname(h.to_string()),
        ),
        map(
            preceded(
                (tag("binding"), space1, tag("state"), space1),
                terminated(
                    alt((
                        value(BindingState::Active, tag("active")),
                        value(BindingState::Free, tag("free")),
                        value(BindingState::Abandoned, tag("abandoned")),
                        value(BindingState::Backup, tag("backup")),
                    )),
                    (space0, char(';')),
                ),
            ),
            LeaseField::BindingState,
        ),
        value(
            LeaseField::Other,
            preceded(
                (tag("uid"), space1),
                terminated(
                    delimited(char('"'), take_until("\""), char('"')),
                    (space0, char(';')),
                ),
            ),
        ),
        value(
            LeaseField::Other,
            (take_till(|c| c == ';' || c == '}'), char(';')),
        ),
    ))
    .parse(input)
}

pub fn parse_lease(input: &str) -> IResult<&str, Lease> {
    let (input, _) = ws(input)?;
    let (input, _) = tag("lease").parse(input)?;
    let (input, _) = space1(input)?;
    let (input, ip) = parse_ip(input)?;
    let (input, _) = space0(input)?;
    let (input, _) = char('{').parse(input)?;
    let (input, _) = ws(input)?;

    let (input, fields) = many0(terminated(parse_field, ws)).parse(input)?;

    let (input, _) = char('}').parse(input)?;
    let (input, _) = ws(input)?;

    let mut lease = Lease {
        ip,
        binding_state: BindingState::Free,
        client_hostname: None,
    };

    for field in fields {
        match field {
            LeaseField::BindingState(s) => lease.binding_state = s,
            LeaseField::ClientHostname(h) => lease.client_hostname = Some(h),
            LeaseField::Other => {}
        }
    }

    Ok((input, lease))
}

pub fn parse_leases(input: &str) -> Result<Vec<Lease>, nom::Err<nom::error::Error<&str>>> {
    let mut leases = Vec::new();
    let Some(start) = input.find("\nlease ") else {
        return Ok(leases);
    };

    let mut remaining = &input[start..];

    while !remaining.is_empty() {
        let (rest, lease) = parse_lease(remaining)?;
        leases.push(lease);
        remaining = rest;
    }
    Ok(leases)
}
