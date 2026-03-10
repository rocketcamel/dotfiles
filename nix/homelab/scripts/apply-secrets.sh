#!/usr/bin/env bash

set -euo pipefail

# SECRETS_DIR="$(cd "$(dirname "$0")/../../../secrets/k3s" && pwd)"
SECRETS_DIR="/home/luca/dotfiles/secrets/k3s"

if [ ! -d "$SECRETS_DIR" ]; then
    echo "Error: secrets directory not found at $SECRETS_DIR"
    exit 1
fi

if ! command -v sops &>/dev/null; then
    echo "Error: sops is not installed"
    exit 1
fi

files=$(find "$SECRETS_DIR" -name '*.yaml' -type f | sort)

if [ -z "$files" ]; then
    echo "No secret files found in $SECRETS_DIR"
    exit 0
fi

failed=0

for file in $files; do
    relative="${file#"$SECRETS_DIR/"}"
    echo "Applying $relative..."
    if ! sops -d "$file" | kubectl apply -f - 2>&1; then
        echo "  FAILED: $relative"
        failed=$((failed + 1))
    fi
done

if [ "$failed" -gt 0 ]; then
    echo ""
    echo "$failed secret(s) failed to apply"
    exit 1
fi

echo ""
echo "All secrets applied successfully"
