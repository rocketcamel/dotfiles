{
  config,
  lib,
  inputs,
  meta,
  ...
}:
{
  options = {
    hm.enable = lib.mkEnableOption "enable home-manager" // {
      default = true;
    };
  };

  config = lib.mkIf config.hm.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.luca = {
        imports = [
          ../../users/luca/home.nix
        ];
      };
      extraSpecialArgs = {
        inherit inputs;
        inherit meta;
      };
    };
  };
}
