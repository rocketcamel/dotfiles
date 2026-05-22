mode="switch"

if [ "$1" ]; then
  mode="$1"
fi

sudo nixos-rebuild $mode --flake ~/dotfiles/nix
