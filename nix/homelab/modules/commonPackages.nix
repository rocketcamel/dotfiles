{
  lib,
  pkgs,
  ...
}:
{
  options = {
    commonPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Common packages";
    };
  };

  config = {
    commonPackages = with pkgs; [
      neovim
      wget
      curl
      k3s
      git
      helmfile
      kubernetes-helm
      nfs-utils
      jj
      stow
      ripgrep
      gcc
      busybox
      bat
      just
      nixfmt
      nixd
      xfsprogs
    ];

    programs.nix-ld = {
      enable = lib.mkDefault true;
      libraries = with pkgs; [
        dbus
      ];
    };

    programs.zsh.enable = true;
    programs.neovim = lib.mkDefault {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      age.sshKeyPaths = [ "/home/luca/.ssh/id_ed25519" ];
      secrets = {
        "k3s_token" = {
          owner = "luca";
        };
      };
    };
  };
}
