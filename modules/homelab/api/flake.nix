{
  description = "Homelab api";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
    in
    {
      devShells = forAllSystems (
        { system, pkgs }:
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              openssl
              pkgconf
            ];
          };
        }
      );
    };
}
