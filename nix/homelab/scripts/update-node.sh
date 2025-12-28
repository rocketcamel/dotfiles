#!/usr/bin/env bash

set -e

HOST="$1"
if [ -z "$HOST" ]; then
    echo "Usage: $0 <ip-or-hostname>"
    exit 1
fi

ssh "$HOST" "cd ~/dotfiles && git pull && sudo nixos-rebuild switch --flake ~/dotfiles/nix/homelab --impure"
