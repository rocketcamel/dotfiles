#!/usr/bin/env bash

set -e

# Route definitions: name:hostname:port:protocol:private
# - name: service name (required)
# - hostname: custom hostname, use '-' for default (name.lucalise.ca)
# - port: service port (required)
# - protocol: TCP (default) or UDP
# - private: true/false (default false) - adds private-networks middleware
ROUTES=(
  "sonarr:-:8989:TCP:true"
  "radarr:-:7878:TCP:true"
  "prowlarr:-:9696:TCP:true"
  "bazarr:-:6767:TCP:true"
  "jellyfin:media:8096:TCP:false"
  "home-assistant:-:8123:TCP:true"
)

DOMAIN="lucalise.ca"
OUTPUT_DIR="kustomize/routes"

generate_http_route() {
  local name="$1"
  local hostname="$2"
  local port="$3"
  local protocol="$4"
  local private="$5"

  if [[ -z "$hostname" || "$hostname" == "-" ]]; then
    hostname="$name"
  fi

  if [[ -z "$protocol" ]]; then
    protocol="TCP"
  fi

  if [[ -z "$private" ]]; then
    private="false"
  fi

  local fqdn="${hostname}.${DOMAIN}"

  local filters_section=""
  if [[ "$private" == "true" ]]; then
    filters_section="      - filters:
          - type: ExtensionRef
            extensionRef:
              group: traefik.io
              kind: Middleware
              name: private-networks
        backendRefs:"
  else
    filters_section="      - backendRefs:"
  fi

  cat <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: ${name}
  namespace: media
spec:
  parentRefs:
    - name: traefik-gateway
      namespace: kube-system
  hostnames:
    - "${fqdn}"
  rules:
${filters_section}
          - name: ${name}
            port: ${port}
EOF
}

write_kustomization() {
  local kustomization_file="${OUTPUT_DIR}/../kustomization.yaml"
  local temp_file=$(mktemp)

  # Collect new route paths
  local route_paths=()
  for route in "${ROUTES[@]}"; do
    IFS=':' read -r name _ _ _ _ <<< "$route"
    route_paths+=("  - ./routes/${name}.yaml")
  done

  local in_resources=false
  local resources_written=false
  
  while IFS= read -r line; do
    # Detect resources section
    if [[ "$line" == "resources:" ]]; then
      in_resources=true
      echo "$line" >> "$temp_file"
      continue
    fi

    # If in resources section
    if [[ "$in_resources" == true ]]; then
      # Check if line is a resource entry (starts with "  - ")
      if [[ "$line" =~ ^[[:space:]]*-[[:space:]] ]]; then
        # Skip route entries, keep everything else
        if [[ "$line" =~ \./routes/ ]]; then
          continue
        else
          echo "$line" >> "$temp_file"
        fi
      else
        # End of resources section - write new routes before moving on
        if [[ "$resources_written" == false ]]; then
          for route_path in "${route_paths[@]}"; do
            echo "$route_path" >> "$temp_file"
          done
          resources_written=true
        fi
        in_resources=false
        echo "$line" >> "$temp_file"
      fi
    else
      echo "$line" >> "$temp_file"
    fi
  done < "$kustomization_file"

  # If file ended while still in resources section, write routes now
  if [[ "$in_resources" == true && "$resources_written" == false ]]; then
    for route_path in "${route_paths[@]}"; do
      echo "$route_path" >> "$temp_file"
    done
  fi

  mv "$temp_file" "$kustomization_file"
  echo "Updated ${kustomization_file} with ${#route_paths[@]} routes"
}

main() {
  mkdir -p "${OUTPUT_DIR}"

  for route in "${ROUTES[@]}"; do
    IFS=':' read -r name hostname port protocol private <<< "$route"
    
    echo "Generating route for ${name}..."
    
    output_file="${OUTPUT_DIR}/${name}.yaml"
    generate_http_route "$name" "$hostname" "$port" "$protocol" "$private" > "$output_file"
    
    echo "  -> ${output_file}"
  done

  echo ""
  write_kustomization
  echo ""
  echo "Done! Generated ${#ROUTES[@]} routes."
}

main "$@"
