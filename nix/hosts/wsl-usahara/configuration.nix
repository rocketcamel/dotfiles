# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  meta,
  ...
}:

{
  imports = [ ];

  wsl.enable = true;
  wsl.defaultUser = "luca";
  networking.hostName = meta.hostname;
  hm.enable = true;
  users.users.luca = {
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.authorized_ssh;
  };

  environment.systemPackages = with pkgs; config.commonPackages ++ [ ];

  system.stateVersion = "24.05";
}
