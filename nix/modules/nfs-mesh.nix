{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nfs-mesh;
  remoteHosts = lib.filter (h: h != config.networking.hostName) cfg.hosts;
in
{
  options.nfs-mesh = {
    enable = lib.mkEnableOption "NFS mesh networking" // {
      default = true;
    };

    hosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "usahara"
        "kumatani"
        "tux"
      ];
      description = ''
        List of hostnames participating in the NFS mesh.
        Each host will export its configured path and mount all other hosts.
      '';
      example = [
        "usahara"
        "kumatani"
        "tux"
      ];
    };

    exportPath = lib.mkOption {
      type = lib.types.str;
      default = "/home/luca";
      description = ''
        Path to export to other hosts in the mesh.
        This will be mounted at /mnt/{hostname} on remote hosts.
      '';
      example = "/home";
    };

    exportOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "rw"
        "sync"
        "no_subtree_check"
        "no_root_squash"
      ];
      description = ''
        NFS export options. Default allows read-write access with no root squashing
        since all hosts are on a trusted Tailscale network.
      '';
    };

    mountOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
        "nfsvers=4.2"
        "soft"
        "timeo=10"
        "retrans=3"
      ];
      description = ''
        NFS mount options. Uses automount for on-demand mounting with idle timeout.
        Soft mount with short timeout to avoid hanging on unreachable hosts.
      '';
    };
  };

  config = lib.mkIf (cfg.enable && lib.elem config.networking.hostName cfg.hosts) {
    boot.supportedFilesystems = [ "nfs" ];

    services.rpcbind.enable = true;

    services.nfs.server = {
      enable = true;
      exports = ''
        ${cfg.exportPath} 100.64.0.0/10(${lib.concatStringsSep "," cfg.exportOptions})
      '';
    };

    systemd.tmpfiles.rules = map (host: "d /mnt/${host} 0755 luca users -") remoteHosts;

    fileSystems = lib.listToAttrs (
      map (host: {
        name = "/mnt/${host}";
        value = {
          device = "${host}:${cfg.exportPath}";
          fsType = "nfs";
          options = cfg.mountOptions;
        };
      }) remoteHosts
    );

    systemd.services.nfs-server = {
      requires = [
        "rpcbind.service"
        "network-online.target"
      ];
      after = [
        "rpcbind.service"
        "network-online.target"
      ];
    };
  };
}
