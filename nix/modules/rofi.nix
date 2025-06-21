{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.rofi = {
    enable = lib.mkEnableOption "enable rofi";
  };

  config = lib.mkIf config.rofi.enable {
    home-manager.users.luca = {

      xdg.configFile = {
        rofi.source = ../../custom/rofi;
      };
    };
  };
}
