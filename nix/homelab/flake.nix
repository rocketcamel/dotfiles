{
  description = "Homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      nixpkgs,
      disko,
      ...
    }:
    let
      nodes = [
        {
          name = "kube";
          architecture = "x86_64-linux";
        }
      ];
      systems = [ "x86_64-linux" ];
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
      nixosConfigurations = builtins.listToAttrs (
        map (node: {
          name = node.name;
          value = nixpkgs.lib.nixosSystem {
            system = node.architecture;
            specialArgs = {
              meta = {
                hostname = node.name;
              };
              inherit inputs;
            };
            modules = [
              {
                networking.firewall.enable = false;
                nix.settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              }
              disko.nixosModules.disko
              inputs.sops-nix.nixosModules.sops
              ../modules/keys.nix
              ./modules/default.nix
              ./nodes/${node.name}/configuration.nix
              ./nodes/${node.name}/hardware-configuration.nix
            ];
          };
        }) nodes
      );
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
