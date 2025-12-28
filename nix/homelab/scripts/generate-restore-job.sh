#!/usr/bin/env bash
set -e

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <server_name> <backup_file>" >&2
  exit 1
fi

SERVER_NAME="$1"
BACKUP_FILE="$2"

cd kustomize

kubectl scale deployment minecraft-$SERVER_NAME --replicas 0

sed -e "s/{{SERVER_NAME}}/$SERVER_NAME/g" \
    -e "s/{{BACKUP_FILE}}/$BACKUP_FILE/g" \
    restore-job.yaml | kubectl apply -f -

cd -
