{ lib, config, ... }:
{
  config = lib.mkIf config.desktop.enable {
    home-manager.users.luca = {
      xdg.configFile = {
        "hypr/hyprlock.conf".source = ../../../custom/hyprlock/hyprlock.conf;
      };
    };
  };
}
