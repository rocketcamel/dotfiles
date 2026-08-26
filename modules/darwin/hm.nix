{ inputs, meta, ... }: {
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.luca = {
      imports = [
        ../home/home.nix
      ];
    };

    extraSpecialArgs = {
      inherit inputs;
      meta = meta // {
        homeDirectory = "/Users/luca";
      };
    };
  };
}
