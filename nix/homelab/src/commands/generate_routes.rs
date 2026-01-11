use std::collections::BTreeSet;

use askama::Template;
use serde::{Deserialize, Serialize};

use crate::HelperError;

#[derive(Serialize, Deserialize, Default, Debug, Clone)]
pub struct Route {
    #[serde(default)]
    kind: RouteKind,
    name: String,
    hostname: Option<String>,
    entrypoint: Option<String>,
    namespace: String,
    service: Option<String>,
    port: i16,
    private: bool,
}

impl Route {
    fn hostname(&self) -> &str {
        self.hostname.as_ref().unwrap_or(&self.name)
    }

    fn service(&self) -> &str {
        self.service.as_ref().unwrap_or(&self.name)
    }
}

#[derive(Serialize, Deserialize, Default, Debug, Clone, PartialEq, Eq, PartialOrd, Ord)]
enum RouteKind {
    #[default]
    HTTP,
    TCP,
}

#[derive(Template)]
#[template(path = "httproute.yaml", escape = "none")]
struct HttpRoute<'a> {
    name: &'a str,
    namespace: &'a str,
    hostname: &'a str,
    service: &'a str,
    port: i16,
    private: bool,
}

#[derive(Template)]
#[template(path = "ingressroutetcp.yaml", escape = "none")]
struct TcpRoute<'a> {
    name: &'a str,
    namespace: &'a str,
    entrypoint: &'a str,
    service: &'a str,
    port: i16,
    private: bool,
}

#[derive(Template)]
#[template(path = "http_middleware_chain.yaml", escape = "none")]
struct MiddlewareChain<'a> {
    namespace: &'a str,
}

pub fn generate_routes(routes: &Vec<Route>) -> Result<(), HelperError> {
    let routes_content = routes.iter().enumerate().try_fold(
        String::new(),
        |mut acc, (i, r)| -> Result<_, HelperError> {
            if i > 0 {
                acc.push_str("\n---\n");
            }
            acc.push_str(&generate_route(r)?);
            Ok(acc)
        },
    )?;
    let chains = generate_chains(routes)?;
    std::fs::write("kustomize/routes.yaml", &routes_content)?;
    std::fs::write("kustomize/traefik/chains.yaml", &chains)?;
    println!("Wrote: {}", routes_content);

    Ok(())
}

fn generate_route(route: &Route) -> Result<String, HelperError> {
    match route.kind {
        RouteKind::HTTP => {
            let template = HttpRoute {
                name: &route.name,
                namespace: &route.namespace,
                hostname: route.hostname(),
                service: route.service(),
                port: route.port,
                private: route.private,
            };
            Ok(template.render()?)
        }
        RouteKind::TCP => {
            let entrypoint = route
                .entrypoint
                .as_ref()
                .ok_or(HelperError::TCPEntryPoint(route.name.clone()))?;
            let template = TcpRoute {
                name: &route.name,
                namespace: &route.namespace,
                entrypoint,
                service: route.service(),
                port: route.port,
                private: route.private,
            };
            Ok(template.render()?)
        }
    }
}

fn generate_chains(routes: &[Route]) -> Result<String, HelperError> {
    let namespaces = routes
        .iter()
        .filter_map(|r| r.private.then_some((r.kind.clone(), &r.namespace)))
        .collect::<BTreeSet<_>>();

    namespaces
        .iter()
        .enumerate()
        .try_fold(String::new(), |mut acc, (i, (kind, namespace))| {
            match kind {
                RouteKind::HTTP => {}
                _ => {
                    return Ok(acc);
                }
            }
            if i > 0 {
                acc.push_str("\n---\n");
            }
            let rendered = match kind {
                RouteKind::HTTP => Some(MiddlewareChain { namespace }.render()?),
                _ => None,
            };
            if let Some(rendered) = rendered {
                acc.push_str(&rendered);
            }
            Ok(acc)
        })
}
