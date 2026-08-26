{
  lib,
  pkgs,
  ...
}:
{
  options = {
    common_packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "common packages";
    };
  };

  config = {
    common_packages = with pkgs; [
      stow
      gh
      neovim
      ripgrep
      git
      gcc
      nixfmt
      wireguard-tools
      fzf
      awscli2
      jq
      bat
      pkg-config
      openssl
      gnupg
      nixd
      sops
    ];
  };
}
