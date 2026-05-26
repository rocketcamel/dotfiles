{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs = {
    zsh = import ./zsh.nix { inherit pkgs; };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
