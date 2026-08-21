{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.sensors = {
    enable = lib.mkEnableOption "enable sensors";
  };

  config = lib.mkIf config.sensors.enable {
    boot.kernelModules = [
      "coretemp"
      "nct6775"
    ];
    systemd.services."sensors-init" = {
      description = "Initialize sensor settings";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/run/current-system/sw/bin/sensors -s";
      };
    };
  };
}
