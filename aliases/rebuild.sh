if [ -z "$1" ]; then
  echo "Usage: rebuild <mode>"
  exit 1
fi

sudo nixos-rebuild $1 --flake ~/dotfiles/nix
