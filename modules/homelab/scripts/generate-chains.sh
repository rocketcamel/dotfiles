#!/usr/bin/env bash

set -e

NAMESPACES=(
  "home"
  "longhorn-system"
  "pihole-system"
  "media"
)

OUTPUT_FILE="kustomize/traefik/chains.yaml"

> "$OUTPUT_FILE"

for i in "${!NAMESPACES[@]}"; do
  ns="${NAMESPACES[$i]}"
  
  if [[ $i -gt 0 ]]; then
    echo "---" >> "$OUTPUT_FILE"
  fi
  
  cat >> "$OUTPUT_FILE" <<EOF
apiVersion: traefik.io/v1alpha1
kind: Middleware
metadata:
  name: private-networks 
  namespace: ${ns}
spec:
  chain:
    middlewares:
      - name: private-networks
        namespace: kube-system
EOF
done

echo "Generated $OUTPUT_FILE with ${#NAMESPACES[@]} namespace chains"
