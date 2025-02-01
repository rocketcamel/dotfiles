{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./commonPackages.nix
    ./hm.nix
    ./i3.nix
    ./kanata.nix
    ./pipewire.nix
    ./keys.nix
  ];
}
