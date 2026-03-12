{
  lib,
  config,
  pkgs,
  inputs,
  meta,
  ...
}:
{
  imports = [
    ./programs.nix
    ./services.nix
    ./theme.nix
    ./wallpaper.nix
    ./idle.nix
  ];

  options.niri-desktop = {
    enable = lib.mkEnableOption "enable niri";
  };

  config = lib.mkIf config.niri-desktop.enable {
    programs.niri.enable = true;
    programs.niri.package = inputs.niri.packages.${meta.architecture}.niri-stable.overrideAttrs {
      doCheck = false;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      config.common = {
        default = [ "gtk" ];
      };
    };

    boot.kernelModules = [
      "iptables"
      "iptable_nat"
      "bluetooth"
      "btusb"
    ];

    virtualisation.docker = {
      enable = true;
      rootless.enable = true;
    };

    home-manager.users.luca = {
      programs.niri.config = builtins.readFile ../../../custom/niri/config.kdl;
    };
  };
}
