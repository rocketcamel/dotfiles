{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "luca";
  home.homeDirectory = "/home/luca";

  programs = {
    git = import ./git.nix;
    zsh = import ./zsh.nix { inherit pkgs; };
    tmux = import ./tmux.nix { inherit pkgs; };
    oh-my-posh = import ./omp.nix;
    eza = import ./eza.nix;
    mise = import ./mise.nix;
  };
  xdg.mimeApps = import ./mime.nix;

  home.packages = with pkgs; [
    nodejs_22
    pnpm
  ];
  systemd.user.services.ssh-add-keys = {
    Unit = {
      Description = "Load SSH keys from YubiKey";
      After = [ "ssh-agent.service" ];
      Requires = [ "ssh-agent.service" ];
    };
    Service = {
      Type = "oneshot";
      Environment = [
        "SSH_AUTH_SOCK=%t/ssh-agent"
        "SSH_ASKPASS=${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass"
        "SSH_ASKPASS_REQUIRE=prefer"
        "DISPLAY=:0"
      ];
      ExecStart = "${pkgs.openssh}/bin/ssh-add -K";
      RemainAfterExit = true;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
