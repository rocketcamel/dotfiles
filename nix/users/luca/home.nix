{ config, pkgs, ... }:

{
  home.username = "luca";
  home.homeDirectory = "/home/luca";

  programs = {
    git = import ./git.nix;
    zsh = import ./zsh.nix;
    tmux = import ./tmux.nix { inherit pkgs; };
    oh-my-posh = import ./omp.nix;
  };

  home.packages = with pkgs; [
    nodejs_22
    pnpm
  ];

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
