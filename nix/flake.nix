{
  description = "Top level flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, nixos-wsl, ... }:
    let
      systems = [ "x86_64-linux" ];
      hosts = [
        {
          name = "wsl-kumatani";
          isWSL = true;
        }
        {
          name = "tux";
          isWSL = false;
        }
      ];
    in {
      nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host.name;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            meta = { hostname = host.name; };
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/${host.name}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              nix.settings.experimental-features = [ "nix-command" "flakes" ];
            }
          ] ++ (if host.isWSL then [ nixos-wsl.nixosModules.default ] else [ ]);
        };
      }) hosts);
    };
}
