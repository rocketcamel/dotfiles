{ config, pkgs, ... }:

{
  home.username = "luca";
  home.homeDirectory = "/home/luca";

  programs = {
    git = import ./git.nix;
    zsh = import ./zsh.nix;
    tmux = import ./tmux.nix { inherit pkgs; };
    helix = import ./helix.nix { inherit pkgs; };
  };

 config.i3.enable ? 

  home.packages = with pkgs; [
    nodePackages_latest.typescript-language-server
    nodejs_22
    pnpm
    gh
    oh-my-posh
  ];

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
