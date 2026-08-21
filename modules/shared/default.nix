{ ... }:
{
  imports = [
    ./common_packages.nix
    ./hm.nix
    ./kanata.nix
    ./pipewire.nix
    ./keys.nix
    ./rofi.nix
    ./desktop/default.nix
    ./virtualization.nix
    ./printing.nix
    ./sensors.nix
    ./dns.nix
    ./mounts.nix
    ./nfs-mesh.nix
    ./rust.nix
    ./i18n.nix
  ];
}
