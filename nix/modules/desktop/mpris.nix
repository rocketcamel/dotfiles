{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    environment.systemPackages = with pkgs; [
      playerctl
    ];

    home-manager.users.luca = {
      services.playerctld.enable = true;

      systemd.user.services.mpris-proxy = {
        Unit = {
          Description = "mpris-proxy - Bluetooth AVRCP to MPRIS bridge";
          After = [
            "sound.target"
          ];
        };
        Service = {
          ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
