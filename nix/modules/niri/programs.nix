{
  pkgs,
  pkgs-before,
  inputs,
  meta,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.niri-desktop.enable {
    environment.systemPackages = with pkgs; [
      vscode-fhs
      pavucontrol
      vlc
      wine64
      firefox
      brightnessctl
      pkgs-before.jellyfin-media-player
      anki-bin
      mpv
      prismlauncher
      dconf
      papirus-icon-theme
      libnotify
      adwaita-icon-theme
      gnome-themes-extra
      wl-clipboard
      wl-clip-persist
      wdisplays
      efibootmgr
      xfce.thunar
      xdg-desktop-portal
      microsoft-edge
      libadwaita
      grim
      grimblast
      slurp
      swappy
      fanctl
      waypipe
      inputs.qml-niri.packages.${meta.architecture}.quickshell
      alacritty
      swaybg
      swayidle
      vesktop
      freerdp
      xwayland-satellite
      r2modman
    ];

    programs = {
      steam.enable = true;
      obs-studio.enable = true;
    };

    programs.dconf.profiles = {
      gdm.databases = [
        {
          settings = {
            "org/gnome/desktop/screensaver" = {
              picture-uri = "file://${../../../custom/login/wallpaper.jpg}";
              picture-uri-dark = "file://${../../../custom/login/wallpaper.jpg}";
              picture-options = "zoom";
            };
          };
        }
      ];
    };

    rofi.enable = true;
    zed.enable = true;
    virt.enable = true;
    printing.enable = true;

    home-manager.users.luca = {
      home.packages = with pkgs; [
        blueberry
      ];
      programs = {
        ghostty = {
          enable = true;
          settings = {
            "shell-integration-features" = "no-cursor";
            "background-opacity" = 0.85;
            "cursor-style" = "block";
            "cursor-style-blink" = false;
            "font-size" = 15;
          };
        };
        ranger.enable = true;
        hyprlock = {
          enable = true;
        };
        obsidian.enable = true;
      };
    };
  };
}
