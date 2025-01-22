{ config, pkgs, ... }:


{
  home.username = "luca";
  home.homeDirectory = "/home/luca";

  programs = {
    git = import ./git.nix;
    alacritty = {
      enable = true;
      settings.window.opacity = 0.6;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
    };
  };

  services.picom = {
    enable = true;
    vSync = true;
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      defaultWorkspace = "workspace number 1";
      terminal = "alacritty";
    };
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

}
