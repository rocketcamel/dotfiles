{
  description = "Top level flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    pesde.url = "github:rocketcamel/pesde-nix";
    pesde.inputs.nixpkgs.follows = "nixpkgs";
    mantle.url = "github:rocketcamel/mantle-nix";
    mantle.inputs.nixpkgs.follows = "nixpkgs";
    rokit.url = "github:rocketcamel/rokit-nix";
    rokit.inputs.nixpkgs.follows = "nixpkgs";
    custom-fonts.url = "path:./fonts";
    custom-fonts.inputs.nixpkgs.follows = "nixpkgs";
    status-bar = {
      url = "path:../astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          architecture = "x86_64-linux";
          isWSL = true;
        }
        {
          name = "wsl-usahara";
          architecture = "x86_64-linux";
          isWSL = true;
        }
        {
          name = "tux";
          architecture = "x86_64-linux";
        }
        {
          name = "tux-wsl";
          architecture = "x86_64-linux";
          isWSL = true;
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
            system = host.architecture;
            modules =
              [
                ./hosts/${host.name}/configuration.nix
                ./modules/default.nix
                home-manager.nixosModules.home-manager
                {
                  nix.settings.experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                  environment.systemPackages = [
                    inputs.pesde.packages.${host.architecture}.default
                    inputs.mantle.packages.${host.architecture}.default
                    inputs.rokit.packages.${host.architecture}.default
                    inputs.status-bar.packages.${host.architecture}.status-bar
                  ];
                  fonts.packages = [
                    inputs.custom-fonts.packages.${host.architecture}.default
                  ];
                  nixpkgs.config.allowUnfree = true;
                }
              ]
              ++ (
                if builtins.hasAttr "isWSL" host then
                  [
                    nixos-wsl.nixosModules.default
                    ./hosts/wsl/configuration.nix
                  ]
                else
                  [ ]
              );
          };
        }) hosts
      );
    };
}
