{ lib, config, ... }:
{
  options.wireguard-layer = {
    enable = lib.mkEnableOption "enable wireguard layer";
  };

  config = lib.mkIf config.wireguard-layer.enable {
    services.consul = {
      enable = true;
      extraConfig = {
        datacenter = "home";
        data_dir = "/var/lib/consul";
        retry_join = [ "192.168.27.14" ];
        bind_addr = "0.0.0.0";
        advertise_addr = "10.100.0.3";
      };
    };
  };
}
