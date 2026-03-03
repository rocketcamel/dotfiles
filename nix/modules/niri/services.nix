{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.niri-desktop.enable {
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
    services.gnome.gcr-ssh-agent.enable = false;

    home-manager.users.luca = {
      services = {
        dunst = {
          enable = true;
          configFile = ../../custom/dunst/dunstrc;
        };
        cliphist.enable = true;
      };

      # Gammastep for night light (replaces hyprsunset)
      services.gammastep = {
        enable = true;
        provider = "manual";
        latitude = 49.28;
        longitude = -123.12;
        temperature = {
          day = 6500;
          night = 3500;
        };
      };

      # Polkit agent (replaces hyprpolkitagent)
      systemd.user.services.polkit-gnome-agent = {
        Unit = {
          Description = "Polkit GNOME authentication agent";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
