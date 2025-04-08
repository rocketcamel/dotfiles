{
  description = "Homelab-test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
    }:
    {
      nixosConfigurations = {
        main = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            meta = {
              hostname = "kube";
            };
          };
          modules = [
            disko.nixosModules.disko
            ./configuration.nix
            ./hardware-configuration.nix
          ];
        };
      };
    };
}
