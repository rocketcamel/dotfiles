{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.desktop = {
    enable = lib.mkEnableOption "enable desktop";
  };

  config = lib.mkIf config.desktop.enable {
    environment.systemPackages = with pkgs; [
      vscode-fhs
      pavucontrol
      vlc
      wine64
      vesktop
      firefox
      brightnessctl
      flameshot
      jellyfin-media-player
      anki-bin
      mpv
      ahk_x11
      prismlauncher
      feh
      dconf
      papirus-icon-theme
      pa_applet
      libnotify
      adwaita-icon-theme
      gnome-themes-extra
      wl-clipboard
      wl-clip-persist
      wdisplays
      efibootmgr
      nixd
      xfce.thunar
      altserver-linux
      xdg-desktop-portal
      microsoft-edge
      libadwaita
      grim
      slurp
      swappy
    ];
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    services.tumbler.enable = true;
    services.xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    wofi.enable = true;
    services.upower.enable = true;
    zed.enable = true;
    virt.enable = true;
    printing.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      config.common = {
        default = "gtk";
      };
    };

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
        hyprlock = {
          enable = true;
        };
        ranger.enable = true;
      };
      xdg.configFile = {
        "hypr/hyprlock.conf".source = ../../custom/hyprlock/hyprlock.conf;
      };
      services.dunst = {
        enable = true;
        configFile = ../../custom/dunst/dunstrc;
      };
      services.hyprpolkitagent.enable = true;
      services.cliphist.enable = true;
      services.hyprpaper = {
        enable = true;
        settings = {
          ipc = "on";
          splash = false;
          preload = [ "~/dotfiles/.config/wallpaper/bg.jpg" ];
          wallpaper = [
            ",~/dotfiles/.config/wallpaper/bg.jpg"
          ];
        };
      };
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
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
            }
          ];
        };
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

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
        extraConfig = ''
          cursor:no_hardware_cursors=1
        '';
        settings = {
          "$mod" = "SUPER";
          "$terminal" = "ghostty";
          "$menu" = "wofi";
          bind = [
            "$mod, Return, exec, $terminal"
            "$mod SHIFT, Q, killactive"
            "$mod SHIFT, E, exit"
            "$mod SHIFT, SPACE, togglefloating"
            "$mod, d, exec, $menu"
            "$mod SHIFT, D, exec, bash -c ~/dotfiles/scripts/workspace.sh"
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"
            "$mod, Space, togglesplit"
            "$mod SHIFT, v, exec, bash -c ~/dotfiles/scripts/copy.sh"

            "$mod, 0, workspace, 10"
            "$mod SHIFT, 0, movetoworkspacesilent, 10"
            "$mod, f, fullscreen"
          ]
          ++ (builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, ${toString ws}, workspace, ${toString ws}"
                "$mod SHIFT, ${toString ws}, movetoworkspacesilent, ${toString ws}"
              ]
            ) 9
          ));
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
          bindel = [
            ",XF86AudioRaiseVolume, exec, bash -c \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && vol=\\\$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int(\\\$2 * 100)}') && notify-send -h int:value:\\\$vol -h string:synchronous:volume -u low \\\"Volume\\\"\""
            ",XF86AudioLowerVolume, exec, bash -c \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && vol=\\\$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int(\\\$2 * 100)}') && notify-send -h int:value:\\\$vol -h string:synchronous:volume -u low \\\"Volume\\\"\""
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessUp, exec, bash -c 'brightnessctl s +5% && perc=$(( \$(brightnessctl get) * 100 / \$(brightnessctl max) )) && notify-send \"Brightness\" -h int:value:\$perc -h string:synchronous:brightness -u low'"
            ",XF86MonBrightnessDown, exec, bash -c 'brightnessctl s 5%- && perc=$(( \$(brightnessctl get) * 100 / \$(brightnessctl max) )) && notify-send \"Brightness\" -h int:value:\$perc -h string:synchronous:brightness -u low'"
          ];
          general = {
            gaps_in = 0;
            gaps_out = 0;
          };
          dwindle = {
            preserve_split = true;
          };
          decoration = {
            rounding = 0;
            blur = {
              enabled = false;
            };
          };
          env = [
            "XCURSOR_THEME,Adwaita"
            "XCURSOR_SIZE,24"
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          ];
          exec-once = [
            "status-bar"
            "wl-clip-persist --clipboard regular"
          ];
          monitor = [
            "eDP-1, 1920x1080, 0x0, 1"
          ];
          input = {
            kb_layout = "us";
            touchpad = {
              natural_scroll = true;
            };
          };
          animations = {
            enabled = false;
          };
        };
      };
    };
  };
}
