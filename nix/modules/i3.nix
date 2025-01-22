{ pkgs, lib, config, ... }: {
  options = { i3.enable = lib.mkEnableOption "enable i3"; };

  config = lib.mkIf config.i3.enable {
    services.xserver = {
      enable = true;
      windowManager.i3.enable = true;
    };

    services.displayManager = { defaultSession = "none+i3"; };

    home-manager.users.luca = {
      programs = {
        alacritty = {
          enable = true;
          settings.window.opacity = 0.6;
        };
      };
    };

    services.picom = {
      enable = true;
      vSync = true;
    };
  };
}
