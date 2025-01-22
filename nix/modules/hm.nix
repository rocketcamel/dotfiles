{ lib, config, pkgs, ... }: {
  options = { hm.enable = lib.mkEnableOption "enable home-manager"; };

  config = lib.mkIf config.hm.enable {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.luca = import ../users/luca/home.nix;
    programs.zsh.enable = true;
  };
}
