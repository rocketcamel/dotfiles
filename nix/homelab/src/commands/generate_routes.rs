use serde::{Deserialize, Serialize};

use crate::{Config, HelperError};

#[derive(Serialize, Deserialize, Default)]
pub struct Route {
    name: String,
    hostname: String,
    namespace: String,
    service: Option<String>,
    port: i16,
    private: bool,
}

pub fn generate_routes(config: &Config) -> Result<(), HelperError> {
    let routes = config
        .routes
        .iter()
        .enumerate()
        .fold(String::new(), |mut acc, (i, r)| {
            if i > 0 {
                acc.push_str("\n---\n");
            }
            acc.push_str(&generate_route(r));
            acc
        });
    std::fs::write("kustomize/routes.yaml", &routes)?;
    println!("Wrote: {}", routes);

    Ok(())
}

fn generate_route(route: &Route) -> String {
    let mut filters_section = String::new();
    if route.private {
        filters_section = format!(
            r#"filters:
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
          port: {}
      {}"#,
        route.name,
        route.namespace,
        route.hostname,
        route.service.clone().unwrap_or_else(|| route.name.clone()),
        route.port,
        filters_section
    )
    .trim_end()
    .to_string()
}
