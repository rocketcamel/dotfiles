use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};

use crate::{HelperError, config::Config};

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
}

#[derive(Serialize, Deserialize, Default, Debug, Clone)]
enum RouteKind {
    #[default]
    HTTP,
    TCP,
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
    let chains = generate_chains(&routes);
    std::fs::write("kustomize/routes.yaml", &routes_content)?;
    std::fs::write("kustomize/traefik/chains.yaml", &chains)?;
    println!("Wrote: {}", routes_content);

    Ok(())
}

fn generate_route(route: &Route) -> Result<String, HelperError> {
    Ok(match route.kind {
        RouteKind::HTTP => generate_http_route(route),
        RouteKind::TCP => generate_tcp_route(route)?,
    })
}

fn generate_chains(routes: &[Route]) -> String {
    let namespaces = routes
        .iter()
        .filter_map(|r| {
            if !r.private {
                return None;
            }
            Some(r.namespace.as_str())
        })
        .collect::<BTreeSet<_>>();

    namespaces
        .iter()
        .enumerate()
        .fold(String::new(), |mut acc, (i, n)| {
            if i > 0 {
                acc.push_str("\n---\n");
            }
            acc.push_str(&format!(
                r#"apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: private-networks 
  namespace: {}
spec:
  chain:
    middlewares:
      - name: private-networks
        namespace: kube-system"#,
                n
            ));
            acc
        })
}

fn generate_http_route(route: &Route) -> String {
    let mut filters_section = String::new();
    if route.private {
        filters_section = format!(
            r#"
      filters:
        - type: ExtensionRef
          extensionRef:
            group: traefik.io
            kind: Middleware
            name: private-networks"#
        );
    };

    format!(
        r#"apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: {}
  namespace: {}
spec:
  parentRefs:
    - name: traefik-gateway
      namespace: kube-system
  hostnames:
    - {}.lucalise.ca
  rules:
    - backendRefs:
        - name: {}
          port: {}{}"#,
        route.name,
        route.namespace,
        route.hostname(),
        route.service.as_ref().unwrap_or_else(|| &route.name),
        route.port,
        filters_section
    )
    .trim_end()
    .to_string()
}

fn generate_tcp_route(route: &Route) -> Result<String, HelperError> {
    let mut middlewares_section = String::new();
    if route.private {
        middlewares_section = format!(
            r#"
      middlewares:
        - name: private-networks"#
        );
    }

    Ok(format!(
        r#"apiVersion: traefik.io/v1alpha1
kind: IngressRouteTCP
metadata:
  name: {}
  namespace: {}
spec:
  entryPoints:
    - {}
  routes:
    - match: HostSNI(`*`){}
      services:
        - name: {}
          port: {}"#,
        route.name,
        route.namespace,
        route
            .entrypoint
            .as_ref()
            .ok_or(HelperError::TCPEntryPoint(route.name.clone()))?,
        middlewares_section,
        route.service.as_ref().unwrap_or_else(|| &route.name),
        route.port
    )
    .trim_end()
    .to_string())
}
