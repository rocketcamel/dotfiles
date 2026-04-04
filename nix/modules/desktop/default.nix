{
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    ./custom.nix
    ./idle.nix
    ./mpris.nix
    ./programs.nix
    ./services.nix
    ./theme.nix
    ./wallpaper.nix
  ];
  options.desktop = {
    enable = lib.mkEnableOption "enable desktop";
  };

  config = lib.mkIf config.desktop.enable {
    boot.kernelModules = [
      "iptables"
      "iptable_nat"
      "bluetooth"
      "btusb"
    ];

    virtualisation.docker = {
      enable = true;
      rootless.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      config.common = {
        default = "gtk";
      };
    };

    home-manager.users.luca = {
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
          "$menu" = "rofi -show drun";
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
            "$mod SHIFT, h, movewindow, l"
            "$mod SHIFT, l, movewindow, r"
            "$mod SHIFT, v, exec, bash -c ~/dotfiles/scripts/copy.sh"
            "$mod SHIFT, s, exec, bash -c ~/dotfiles/scripts/screenshot.sh"
            "$mod, p, exec, bash -c ~/dotfiles/scripts/project.sh"
            "$mod SHIFT, k, exec, bash -c ~/dotfiles/scripts/layout.sh"
            "$mod CTRL, h, focusmonitor, l"
            "$mod CTRL, l, focusmonitor, r"

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
          bindl = [
            ",XF86AudioPlay, exec, playerctl play-pause"
            ",XF86AudioNext, exec, playerctl next"
            ",XF86AudioPrev, exec, playerctl previous"
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
            gaps_in = 5;
            gaps_out = 10;
          };
          dwindle = {
            preserve_split = true;
          };
          decoration = {
            rounding = 10;
            blur = {
              enabled = false;
            };
          };
          windowrule = [
            "float, class:^(org.prismlauncher.PrismLauncher)$"
            "size 900 600, class:^(org.prismlauncher.PrismLauncher)$, title:^(Prism Launcher)(.*)"

            "float, class:.*pavucontrol*."
            "size 800 600, class:.*pavucontrol*."
            "float, class:^(thunar)$"
            # "size 1000 600, class:^(thunar)$"

            "float, class:^(xdg-desktop-portal-gtk)$"
            "size 1000 600, class:^(xdg-desktop-portal-gtk)$"

            "float, class:^(steam)$"
            "float, class:^(blueberry.py)$"
            "size 800 600, class:^(blueberry.py)$"
          ];
          env = [
            "XCURSOR_THEME,Adwaita"
            "XCURSOR_SIZE,24"
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          ];
          exec-once = [
            "qs"
            "wl-clip-persist --clipboard regular"
          ];
          monitor = [
            "eDP-1, 1920x1080, 0x0, 1"
          ];
          input = {
            kb_layout = "us,jp";
            touchpad = {
              natural_scroll = true;
            };
          };
          animations = {
            enabled = true;

            bezier = [
              "easeOutQuint, 0.23, 1, 0.32, 1"
              "easeInOutCubic, 0.65, 0.05, 0.36, 1"
              "linear, 0, 0, 1, 1"
              "almostLinear, 0.5, 0.5, 0.75, 1"
              "quick, 0.15, 0, 0.1, 1"
            ];

            animation = [
              "global, 1, 10, default"
              "border, 0, 5.39, easeOutQuint"
              "windows, 0, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 0, 1.73, almostLinear"
              "fadeOut, 0, 1.46, almostLinear"
              "fade, 0, 3.03, quick"
              "layers, 0, 3.81, easeOutQuint"
              "layersIn, 0, 4, easeOutQuint, fade"
              "layersOut, 0, 1.5, linear, fade"
              "fadeLayersIn, 0, 1.79, almostLinear"
              "fadeLayersOut, 0, 1.39, almostLinear"
              "workspaces, 0, 1.94, almostLinear, fade"
              "workspacesIn, 0, 1.21, almostLinear, fade"
              "workspacesOut, 0, 1.94, almostLinear, fade"
            ];
          };
        };
      };
    };
  };
}
