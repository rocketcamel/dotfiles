{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.keyd = {
    enable = lib.mkEnableOption "enable keyd";
  };

  config = lib.mkIf config.keyd.enable {
    users.extraGroups.keyd = {
      name = "keyd";
    };
    users.users.luca.extraGroups = [ "keyd" ];
    environment.systemPackages = with pkgs; [
      keyd
    ];
    services.keyd = {
      enable = true;
      keyboards.main = {
        settings = {
          main = {
            capslock = "esc";
          };
        };
      };
    };
  };
}
