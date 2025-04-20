{
  description = "Homelab";

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
    }@inputs:
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
            };
            modules = [
              disko.nixosModules.disko
              ./${node.name}-configuration.nix
              ./${node.name}-hardware-configuration.nix
              ./${node.name}-disk-config.nix
            ];
          };
        }) nodes
      );
    };
}
