{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    i3.enable = lib.mkEnableOption "enable i3";
  };

  config = lib.mkIf config.i3.enable {
    services.xserver = {
      enable = true;
      windowManager.i3.enable = true;
      xkb = {
        options = "grp:alt_shift_toggle";
        layout = "us";
      };
      serverLayoutSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';
    };

    services.displayManager = {
      defaultSession = "none+i3";
    };
    services.libinput.touchpad.naturalScrolling = true;

    environment.systemPackages = with pkgs; [
      vscode-fhs
      pavucontrol
      vlc
      vinegar
      wine64
      vesktop
      firefox
      brightnessctl
      arandr
      flameshot
      jellyfin-media-player
      anki-bin
      mpv
      ahk_x11
      prismlauncher
      feh
      dconf
      rofi
      papirus-icon-theme
      pa_applet
      libnotify
    ];
    programs.thunar.enable = true;
    services.tumbler.enable = true;
    # rofi.enable = true;

    home-manager.users.luca = {
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
      };
      services.dunst = {
        enable = true;
        configFile = ../../custom/dunst/dunstrc;
      };
      gtk = {
        enable = true;
        theme.name = "Adwaita-dark";
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
      qt = {
        enable = true;
        style.name = "adwaita-dark";
      };

      services.picom = {
        enable = true;
        vSync = true;
      };
      services.copyq.enable = true;

      xsession.windowManager.i3 = {
        enable = true;
        extraConfig = ''
          exec --no-startup-id pa-applet
          for_window [all] title_window_icon padding 3px
          exec --no-startup-id feh --bg-scale ~/.config/wallpaper/bg.jpg
        '';
        config = {
          modifier = "Mod4";
          defaultWorkspace = "workspace number 1";
          terminal = "ghostty";
          fonts = {
            names = [
              "Noto Sans"
              "Noto Sans CJK JP"
              "Open Sans"
              "Feather"
            ];
            size = 10.0;
          };
          keybindings =
            let
              modifier = "Mod4";
            in
            lib.mkOptionDefault {
              "XF86MonBrightnessUp" =
                "exec bash -c 'brightnessctl s +5% && perc=$(( \$(brightnessctl get) * 100 / \$(brightnessctl max) )) && notify-send \"Brightness\" -h int:value:\$perc'";
              "XF86MonBrightnessDown" =
                "exec bash -c 'brightnessctl set 5%- && perc=$(( \$(brightnessctl get) * 100 / \$(brightnessctl max) )) && notify-send \"Brightness\" -h int:value:\$perc'";
              "${modifier}+h" = "focus left";
              "${modifier}+j" = "focus down";
              "${modifier}+k" = "focus up";
              "${modifier}+l" = "focus right";
              "${modifier}+Shift+h" = "move left";
              "${modifier}+Shift+j" = "move down";
              "${modifier}+Shift+k" = "move up";
              "${modifier}+Shift+l" = "move right";
              "${modifier}+d" = "exec rofi -show drun -theme ~/.config/rofi/launcher.rasi";
            };
          #startup = [
          #  {
          #    command = "volumeicon";
          #  }
          #];
        };
      };
    };
  };
}
