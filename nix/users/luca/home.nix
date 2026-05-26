{
  config,
  pkgs,
  lib,
  inputs,
  meta,
  ...
}:

{
  imports = [
    ./shell/default.nix
  ];
  home.username = "luca";
  home.homeDirectory = "/home/luca";

  programs = {
    git = import ./git.nix;
    tmux = import ./tmux.nix { inherit pkgs; };
    eza = import ./eza.nix;
    mise = import ./mise.nix;
    bacon.enable = true;
    jujutsu = import ./jj.nix;
  };
  xdg.mimeApps = import ./mime.nix;

  home.packages = with pkgs; [
    nodejs_22
    pnpm
    inputs.matugen.packages.${meta.architecture}.default
  ];

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
