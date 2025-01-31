{
  description = "Top level flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixos-wsl,
      ...
    }:
    let
      hosts = [
        {
          name = "wsl-kumatani";
          isWSL = true;
        }
        {
          name = "wsl-usahara";
          isWSL = true;
        }
        {
          name = "tux";
        }
      ];
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host.name;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              meta = {
                hostname = host.name;
              };
            };
            system = "x86_64-linux";
            modules = [
              ./hosts/${host.name}/configuration.nix
              ./modules/default.nix
              home-manager.nixosModules.home-manager
              {
                nix.settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];
              }
            ] ++ (if builtins.hasAttr "isWSL" host then [ nixos-wsl.nixosModules.default ] else [ ]);
          };
        }) hosts
      );
    };
}
