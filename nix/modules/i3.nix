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
      kdePackages.dolphin
      vscode-fhs
      pavucontrol
      vlc
      vinegar
      wine64
      vesktop
      firefox
      brightnessctl
      volumeicon
      arandr
      flameshot
      jellyfin-media-player
      anki-bin
      mpv
      ahk_x11
    ];

    home-manager.users.luca = {
      programs = {
        alacritty = {
          enable = true;
          settings = {
            window.opacity = 0.6;
          };
        };
      };
      services.dunst = {
        enable = true;
      };

      services.picom = {
        enable = true;
        vSync = true;
      };
      services.copyq.enable = true;

      xsession.initExtra = ''
        xset s off
        xset s noblank
      '';
      xsession.windowManager.i3 = {
        enable = true;
        extraConfig = ''
          exec --no-startup-id sleep 2 && volumeicon
        '';
        config = {
          modifier = "Mod4";
          defaultWorkspace = "workspace number 1";
          terminal = "alacritty";
          fonts = {
            names = [
              "Noto Sans"
              "Noto Sans CJK JP"
            ];
            size = 10.0;
          };
          keybindings =
            let
              modifier = config.xsession.windowManager.i3.config.modifier;
            in
            lib.mkOptionDefault {
              "XF86AudioRaiseVolume" = "exec pamixer -i 5";
              "XF86AudioLowerVolume" = "exec pamixer -d 5";
              "XF86MonBrightnessUp" = "exec brightnessctl s +5%";
              "XF86MonBrightnessDown" = "exec brightnessctl s 5%-";
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
