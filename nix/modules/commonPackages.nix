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
    ];
    programs.nix-ld.enable = true;

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
