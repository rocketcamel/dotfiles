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
      dolphin
      vscode-fhs
      pavucontrol
      vlc
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

      services.picom = {
        enable = true;
        vSync = true;
      };

      xsession.initExtra = ''
        xset s off
        xset s noblank
      '';
      xsession.windowManager.i3 = {
        enable = true;
        config = {
          modifier = "Mod4";
          defaultWorkspace = "workspace number 1";
          terminal = "alacritty";
          keybindings =
            let
              modifier = config.xsession.windowManager.i3.config.modifier;
            in
            lib.mkOptionDefault {
              "XF86AudioRaiseVolume" = "exec pamixer -i 5";
              "XF86AudioLowerVolume" = "exec pamixer -d 5";
            };
        };
      };
    };
  };
}
