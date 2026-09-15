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
      settings.Resolve = {
        DNS = [
          "127.0.0.1:5353"
        ];
        Domains = [
          "home.lan"
        ];
      };
    };

    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = false;

      settings = {
        listen-address = "127.0.0.1";
        port = 5353;
        bind-interfaces = true;

        no-resolv = true;
        no-hosts = true;

        strict-order = true;
        server = [
          "192.168.27.13"
          "1.1.1.1"
          "1.0.0.1"
        ];

        fast-dns-retry = "1000,10000";
      };
    };
  };
}
