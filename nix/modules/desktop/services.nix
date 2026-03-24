{ lib, config, ... }:
{
  config = lib.mkIf config.desktop.enable {
    services.tumbler.enable = true;
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    services.upower.enable = true;
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    home-manager.users.luca = {
      services = {
        dunst = {
          enable = true;
          configFile = ../../custom/dunst/dunstrc;
        };
        hyprpolkitagent.enable = true;
        cliphist.enable = true;
        gammastep = {
          enable = true;
          provider = "manual";
          latitude = 49.28;
          longitude = -123.12;
          temperature = {
            day = 6500;
            night = 3500;
          };
        };

        # hyprsunset = {
        #   enable = true;
        #   settings = {
        #     profile = [
        #       {
        #         time = "6:00";
        #         identity = true;
        #       }
        #       {
        #         time = "21:00";
        #         temperature = 3500;
        #         gamma = 0.8;
        #       }
        #     ];
        #   };
        # };
      };
    };
  };
}
