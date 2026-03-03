{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.niri-desktop.enable {
    security.pam.services.swaylock = { };

    home-manager.users.luca = {
      services.swayidle = {
        enable = true;
        events = [
          {
            event = "before-sleep";
            command = "loginctl lock-session";
          }
          {
            event = "lock";
            command = "loginctl lock-session";
          }
        ];
        timeouts = [
          {
            timeout = 150;
            command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
            resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            timeout = 330;
            command = "niri msg action power-off-monitors";
            resumeCommand = "niri msg action power-on-monitors";
          }
        ];
      };

      programs.swaylock = {
        enable = true;
        settings = {
          color = "1a1b26";
          inside-color = "1a1b26";
          ring-color = "7aa2f7";
          key-hl-color = "9ece6a";
          bs-hl-color = "f7768e";
          text-color = "c0caf5";
          indicator-radius = 100;
          show-failed-attempts = true;
        };
      };
    };
  };
}
