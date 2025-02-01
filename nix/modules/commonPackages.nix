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
      oh-my-posh
      neovim
      ripgrep
      git
      gcc
      rustup
      nixfmt-rfc-style
      asciiquarium
      wireguard-tools
      fzf
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
