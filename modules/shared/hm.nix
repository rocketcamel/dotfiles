{
  lib,
  config,
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
          ../home/home.nix
        ]
        ++ lib.optionals config.desktop.enable [ ../home/desktop/default.nix ];
      };
      extraSpecialArgs = {
        inherit inputs;
        meta = meta // {
          homeDirectory = "/home/luca";
        };
      };
    };
  };
}
