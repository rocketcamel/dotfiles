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
      vinegar
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
      rofi
      papirus-icon-theme
      pa_applet
      libnotify
      adwaita-icon-theme
      swaybg
      gnome-themes-extra
    ];
    programs.thunar.enable = true;
    programs.hyprland.enable = true;
    services.tumbler.enable = true;
    services.displayManager.ly.enable = true;
    rofi.enable = true;
    services.upower.enable = true;

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
      };
      xdg.configFile = {
        "hypr/hyprlock.conf".source = ../../custom/hyprlock/hyprlock.conf;
      };
      services.dunst = {
        enable = true;
        configFile = ../../custom/dunst/dunstrc;
      };
      services.hyprpolkitagent.enable = true;
      services.copyq.enable = true;
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
        settings = {
          "$mod" = "SUPER";
          "$terminal" = "ghostty";
          "$menu" = "rofi -show drun -theme ~/.config/rofi/launcher.rasi";
          bind =
            [
              "$mod, Return, exec, $terminal"
              "$mod SHIFT, Q, killactive"
              "$mod SHIFT, E, exit"
              "$mod SHIFT, SPACE, togglefloating"
              "$mod, d, exec, $menu"
              "$mod, h, movefocus, l"
              "$mod, l, movefocus, r"
              "$mod, k, movefocus, u"
              "$mod, j, movefocus, d"

              "$mod, 0, workspace, 10"
              "$mod SHIFT, 0, movetoworkspacesilent, 10"
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
          decoration = {
            rounding = 0;
            blur = {
              enabled = false;
            };
          };
          env = [
            "XCURSOR_THEME, Adwaita"
            "XCURSOR_SIZE,24"
          ];
          exec-once = [
            "swaybg -i ~/.config/wallpaper/bg.jpg"
            "status-bar"
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
