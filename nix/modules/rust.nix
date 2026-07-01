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
      (pkgs.fenix.combine [
        pkgs.fenix.stable.cargo
        pkgs.fenix.stable.clippy
        pkgs.fenix.stable.rust-src
        pkgs.fenix.stable.rustc
        pkgs.fenix.stable.rustfmt
        pkgs.fenix.targets.wasm32-unknown-unknown.stable.rust-std
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
      brotli
      unixodbc
      glib
    ];
  };
}
