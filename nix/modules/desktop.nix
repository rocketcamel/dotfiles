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
    ];
    programs.thunar.enable = true;
    programs.hyprland.enable = true;
    services.tumbler.enable = true;
    services.displayManager.ly.enable = true;
    # services.displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    # };
    rofi.enable = true;

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
        waybar = {
          enable = true;
        };
      };
      xdg.configFile = {
        "waybar".source = ../../custom/waybar;
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

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
        plugins = with pkgs; [
          hyprlandPlugins.hy3
        ];
        settings = {
          "$mod" = "SUPER";
          "$terminal" = "ghostty";
          "$menu" = "rofi -show drun -theme ~/.config/rofi/launcher.rasi";
          bind = [
            "$mod, Return, exec, $terminal"
            "$mod SHIFT, Q, killactive"
            "$mod SHIFT, E, exit"
            "$mod SHIFT, SPACE, togglefloating"
            "$mod, d, exec, $menu"
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"

            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod, 0, workspace, 10"
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"
            "$mod SHIFT, 0, movetoworkspace, 10"
          ];
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];
          bindel = [
            ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessUp, exec, bash -c 'brightnessctl s +5% && perc=$(( \$(brightnessctl get) * 100 / \$(brightnessctl max) )) && notify-send \"Brightness\" -h int:value:\$perc'"
            ",XF86MonBrightnessDown, exec, bash -c 'brightnessctl s 5%- && perc=$(( \$(brightnessctl get) * 100 / \$(brightnessctl max) )) && notify-send \"Brightness\" -h int:value:\$perc'"
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
            "waybar"
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
