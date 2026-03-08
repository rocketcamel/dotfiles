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
    ];
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
