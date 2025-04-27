{ pkgs, lib, ... }:
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
      wget
      busybox
      curl
      stow
      gh
      neovim
      ripgrep
      git
      gcc
      rustup
      nixfmt-rfc-style
      asciiquarium
      wireguard-tools
      fzf
      lune
      awscli2
      deno
      jq
      nfs-utils
      bluetui
    ];
    programs.nix-ld.enable = lib.mkDefault true;
    programs.zsh.enable = lib.mkDefault true;
    services.openssh.enable = lib.mkDefault true;

    programs.neovim = lib.mkDefault {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
