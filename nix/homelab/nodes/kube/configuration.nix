{
  config,
  lib,
  pkgs,
  meta,
  ...
}:

{
  imports = [
    ./disk-config.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/nvme0n1";
  };

  networking.hostName = meta.hostname;
  networking.networkmanager.enable = true;
  networking.firewall.extraCommands = ''
    iptables -I INPUT -d 192.168.27.10/32 -s 10.0.0.0/8 -j ACCEPT
    iptables -I INPUT -d 192.168.27.10/32 -s 172.16.0.0/12 -j ACCEPT
    iptables -I INPUT -d 192.168.27.10/32 -s 192.168.0.0/16 -j ACCEPT
    iptables -I INPUT -d 192.168.27.10/32 -j DROP
  '';

  time.timeZone = "America/Vancouver";

  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin"
  ];

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = /var/lib/rancher/k3s/server/token;
    clusterInit = true;
    extraFlags = toString [
      "--write-kubeconfig-mode \"0644\""
      "--disable servicelb"
      "--disable local-storage"
    ];
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.2020-08.org.linux-iscsi.initiatorhost:${meta.hostname}";
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.luca = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    hashedPassword = config.hashedPassword;
    openssh.authorizedKeys.keys = config.authorized_ssh;
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    k3s
    git
    helmfile
    kubernetes-helm
    nfs-utils
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.11";

}
