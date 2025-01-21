{
  description = "Top level flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
      hosts = [{
        name = "wsl-kumatani";
        isWSL = true;
      }];
    in {
      nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host.name;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            meta = { hostname = host.name; };
          };
          system = "x86_64-linux";
          modules =
            [ ./configuration.nix home-manager.nixosModules.home-manager ]
            ++ (if host.isWSL then [
              ./wsl.nix
              nixos-wsl.nixosModules.default
            ] else
              [ ]);
        };
      }) hosts);
    };
}
