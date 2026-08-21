{
  description = "root flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager?ref=release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    custom-fonts = {
      url = "path:modules/fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell?rev=1a4716cde794a59928d9d9fc15f2afc7a95de360";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    matugen = {
      url = "github:/InioX/Matugen?ref=v4.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silent-sddm = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      hosts = [
        {
          name = "tux";
          architecture = "x86_64-linux";
        }
        {
          name = "kumatani";
          architecture = "x86_64-linux";
        }
        {
          name = "usahara";
          architecture = "x86_64-linux";
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
                architecture = host.architecture;
              };
            };

            system = host.architecture;

            modules = [
              ./modules/machines/${host.name}/configuration.nix
              ./modules/shared/default.nix
              inputs.sops-nix.nixosModules.sops
              home-manager.nixosModules.home-manager

              {
                nix.settings = {
                  experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                  substituters = [ "https://hyprland.cachix.org" ];
                  trusted-substituters = [ "https://hyprland.cachix.org" ];
                  trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
                };

                fonts.packages = [
                  inputs.custom-fonts.packages.${host.architecture}.default
                ];

                nixpkgs.config.allowUnfree = true;
              }
            ];
          };
        }) hosts
      );
    };
}
