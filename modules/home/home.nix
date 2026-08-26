{
  pkgs,
  meta,
  ...
}:

{
  imports = [
    ./shell/default.nix
    ./editor.nix
  ];

  home.username = "luca";
  home.homeDirectory = meta.homeDirectory;

  programs = {
    git = import ./git.nix;
    tmux = import ./tmux.nix { inherit pkgs; };
    eza = import ./eza.nix;
    mise = import ./mise.nix;
    bacon.enable = true;
    jujutsu = import ./jj.nix;
  };

  home.packages = with pkgs; [
    nodejs_22
    pnpm
  ];

  services.syncthing = {
    enable = true;
  };

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
