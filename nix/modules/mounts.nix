{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.mounts = {
    enable = lib.mkEnableOption "enable mounts" // {
      default = true;
    };
  };

  config = lib.mkIf config.mounts.enable {
    boot.supportedFilesystems = [ "nfs" ];
    services.rpcbind.enable = true;

    systemd.tmpfiles.rules = [ "d /mnt/data 0755 luca users -" ];
    fileSystems = {
      "/mnt/data" = {
        device = "rufus:/data";
        fsType = "nfs";
        options = [
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=600"
        ];
      };
    };
  };
}
