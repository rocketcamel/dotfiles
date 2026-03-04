{ lib, config, ... }:
{
  config = lib.mkIf config.desktop.enable {
    home-manager.users.luca = {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
            {
              timeout = 150;
              on-timeout = "brightnessctl -s set 10";
              on-resume = "brightnessctl -r";
            }
            {
              timeout = 330;
              on-timeout = "niri msg action power-off-monitors";
              on-resume = "niri msg action power-on-monitors && brightnessctl -r";
            }
          ];
        };
      };
    };
  };
}
