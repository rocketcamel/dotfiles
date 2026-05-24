{
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    ./custom.nix
    ./idle.nix
    ./mpris.nix
    ./programs.nix
    ./services.nix
    ./theme.nix
    ./wallpaper.nix
  ];
  options.desktop = {
    enable = lib.mkEnableOption "enable desktop";
  };

  config = lib.mkIf config.desktop.enable {
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

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      config.common = {
        default = "gtk";
      };
    };

    home-manager.users.luca = {
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
      };
    };
  };
}
