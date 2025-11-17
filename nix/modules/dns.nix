{
  lib,
  config,
  ...
}:
{
  options.dns = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable dns";
    };
  };

  config = lib.mkIf config.dns.enable {
    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    services.resolved = {
      enable = true;
      fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      domains = [
        "consul"
        "service.consul"
        "node.consul"
      ];
      extraConfig = ''
        [Resolve]
        DNS=192.168.20.5:8600
      '';
    };

  };
}
