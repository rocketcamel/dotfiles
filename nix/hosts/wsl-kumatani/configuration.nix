# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, meta, ... }:

{
  imports = [ ../../modules/default.nix ];

  wsl.enable = true;
  wsl.defaultUser = "luca";
  networking.hostName = meta.hostname;
  programs.nix-ld.enable = true;
  hm.enable = true;

  environment.systemPackages = with pkgs;
    config.commonPackages ++ [ asciiquarium ];

  system.stateVersion = "24.05";
}
