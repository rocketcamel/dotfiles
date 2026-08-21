{
  description = "NixOS ISO";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    modules = {
      url = "path:../modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    {
      nixosConfigurations = {
        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            inputs.modules.nixosModules.keys
            (
              {
                config,
                ...
              }:
              {
                users.users = {
                  nixos.openssh.authorizedKeys.keys = config.authorized_ssh;
                  root.openssh.authorizedKeys.keys = config.authorized_ssh;
                };
                services.openssh.enable = true;
              }
            )
          ];
        };
      };
    };
}
