{
  description = "Desktop widgets";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ags,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      extraPkgs = with ags.packages.${system}; [
        hyprland
        battery
        wireplumber
        network
      ];
    in
    {
      packages.${system} = {
        status-bar = ags.lib.bundle {
          inherit pkgs;
          src = ./.;
          name = "status-bar";
          entry = "app.ts";

          extraPackages =
            with pkgs;
            extraPkgs
            ++ [
              libgtop
            ];
        };
      };

      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = [
            (ags.packages.${system}.default.override {
              extraPackages =
                with pkgs;
                extraPkgs
                ++ [
                  libgtop
                ];
            })
          ];
        };
      };
    };
}
