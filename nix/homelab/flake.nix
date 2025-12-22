{
  description = "Homelab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      disko,
    }:
    let
      nodes = [
        {
          name = "kube";
          architecture = "x86_64-linux";
        }
      ];
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
              disko.nixosModules.disko
              ../modules/keys.nix
              ./nodes/${node.name}/configuration.nix
              ./nodes/${node.name}/hardware-configuration.nix
              ./nodes/${node.name}/disk-config.nix
            ];
          };
        }) nodes
      );
    };
}
