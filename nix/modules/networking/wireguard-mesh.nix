{
  pkgs,
  lib,
  config,
  ...
}:
let
  meshHosts = {
    kumatani = {
      address = "kumatani";
      publicKey = "pKkl30tba29FG86wuaC0KrpSHMr1tSOujikHFbx75BM=";
      isRouter = false;
      ip = "10.100.0.1";
    };
    usahara = {
      address = "usahara";
      publicKey = "4v7GyAIsKfwWjLMVB4eoosJDvLkIDHW0KsEYoQqSnh4=";
      isRouter = false;
      ip = "10.100.0.2";
    };
    tux = {
      address = "tux";
      publicKey = "Z17ci3Flk1eDAhJ8QZSUgtmlw6BVu4XqvpqLKLWTYWw=";
      isRouter = false;
      ip = "10.100.0.3";
    };
    oakbay-pfsense = {
      endpoint = "oakbay.lucalise.ca:51822";
      publicKey = "xOTPZBIC9m1BkkiLCOUTty3b7/NOvslteVQHzEFxqWQ=";
      isRouter = true;
      ip = "10.100.0.250";
      routes = [
        "10.100.0.0/24"
        "192.168.15.0/27"
        "192.168.20.0/26"
        "192.168.27.0/24"
      ];
    };
    pearce-udm = {
      endpoint = "pearce.lucalise.ca:51823";
      publicKey = "hDb2DzI+isaqXLdxwAF1hc5Nid8TK/M1SQ+zDpf9QxY=";
      isRouter = true;
      ip = "10.100.0.251";
      routes = [
        "192.168.18.0/27"
      ];
    };
  };

  getEndpoint =
    name: host:
    if host.isRouter or false then "${host.endpoint}" else "${host.address}:${toString 51820}";

  mkPeer = name: host: {
    publicKey = host.publicKey;
    allowedIPs = [ "${host.ip}/32" ] ++ (host.routes or [ ]);
    endpoint = getEndpoint name host;
    persistentKeepalive = 25;
    dynamicEndpointRefreshSeconds = 300;
  };

  mkPeersFor =
    selfName:
    lib.mapAttrsToList mkPeer (
      lib.filterAttrs (name: host: name != selfName && (host.isRouter or false)) meshHosts
    );

  selfConfig = meshHosts.${config.networking.hostName} or null;
in
{
  config = lib.mkIf (selfConfig != null) {
    networking.wireguard.interfaces = {
      wg0 = {
        privateKeyFile = "/etc/wireguard/private.key";
        ips = [ "${selfConfig.ip}/32" ];
        listenPort = 51820;
        peers = mkPeersFor config.networking.hostName;
      };
    };

    networking.firewall = {
      allowedUDPPorts = [ 51820 ];
      trustedInterfaces = [ "wg0" ];
    };

    systemd.tmpfiles.rules = [
      "d /etc/wireguard 0700 root root -"
    ];
  };
}
