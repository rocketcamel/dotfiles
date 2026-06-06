{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    services.tumbler.enable = true;
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.upower.enable = true;
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    home-manager.users.luca = {
      services = {
        hyprpolkitagent.enable = true;
        cliphist.enable = true;
        awww.enable = true;
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
