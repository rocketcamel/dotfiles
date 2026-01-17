{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.rust = {
    enable = lib.mkEnableOption "enable rust" // {
      default = true;
    };
  };

  config = lib.mkIf config.rust.enable {
    nixpkgs.overlays = [ inputs.fenix.overlays.default ];
    environment.systemPackages = with pkgs; [
      (pkgs.fenix.stable.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      openssl
      pkgconf
    ];
    environment.variables = {
      PKG_CONFIG_PATH =
        with pkgs;
        lib.makeSearchPath "/lib/pkgconfig" [
          openssl.dev
        ];
      LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
    };
    programs.nix-ld.libraries = with pkgs; [
      openssl
      zlib
    ];
  };
}
