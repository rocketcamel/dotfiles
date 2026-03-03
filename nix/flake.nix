{
  description = "Top level flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-before.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    custom-fonts.url = "path:./fonts";
    custom-fonts.inputs.nixpkgs.follows = "nixpkgs";

    # status-bar = {
    #   url = "github:rocketcamel/dotfiles-status-bar";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qml-niri = {
      url = "github:imiric/qml-niri/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.niri-stable.url = "git+https://git.lucalise.ca/lucalise/niri?ref=niri-custom";
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
              pkgs-before = import inputs.nixpkgs-before { system = host.architecture; };
            };
            system = host.architecture;
            modules = [
              ./hosts/${host.name}/configuration.nix
              ./modules/default.nix
              inputs.sops-nix.nixosModules.sops
              inputs.niri.nixosModules.niri
              home-manager.nixosModules.home-manager
              {
                nix.settings.experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                environment.systemPackages = [
                  # inputs.status-bar.packages.${host.architecture}.default
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
