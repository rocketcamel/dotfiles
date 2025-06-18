{
  description = "custom-fonts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      fonts = pkgs.callPackage ./custom-fonts.nix { };
    in
    {
      packages.x86_64-linux.default = fonts;
    };
}
