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
      ghostty-bin
    ];

    home-manager.users.luca = {
      programs.ghostty = {
        enable = true;
        package = pkgs.ghostty-bin;
        settings = {
          "shell-integration-features" = "no-cursor";
          "background-opacity" = 0.85;
          "cursor-style" = "block";
          "cursor-style-blink" = false;
          "font-size" = 15;
          "theme" = "Matugen";
        };
      };
    };
  };
}
