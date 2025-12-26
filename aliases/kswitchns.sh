#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: kswitchns <namespace>"
    echo "Current namespace: $(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo 'default')"
    echo ""
    echo "Available namespaces:"
    kubectl get namespaces --no-headers -o custom-columns=":metadata.name"
    exit 1
fi

NAMESPACE="$1"

# Verify namespace exists
if ! kubectl get namespace "$NAMESPACE" &>/dev/null; then
    echo "Error: Namespace '$NAMESPACE' does not exist"
    echo ""
    echo "Available namespaces:"
    kubectl get namespaces --no-headers -o custom-columns=":metadata.name"
    exit 1
fi

# Set namespace for current context
kubectl config set-context --current --namespace="$NAMESPACE"

echo "Switched to namespace: $NAMESPACE"
