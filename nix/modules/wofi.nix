{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.wofi = {
    enable = lib.mkEnableOption "enable wofi";
  };

  config = lib.mkIf config.wofi.enable {
    environment.systemPackages = with pkgs; [ wofi ];
    home-manager.users.luca = {
      xdg.configFile = {
        wofi.source = ../../custom/wofi;
      };
    };
  };
}
