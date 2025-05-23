{
  config,
  lib,
  pkgs,
  meta,
  ...
}:

{
  imports = [
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  networking.hostName = meta.hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "America/Vancouver";

  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin"
  ];

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = /var/lib/rancher/k3s/server/token;
    clusterInit = true;
    extraFlags = toString ([
      "--write-kubeconfig-mode \"0644\""
      "--disable local-storage"
    ]);
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.2020-08.org.linux-iscsi.initiatorhost:${meta.hostname}";
  };

  security.sudo.wheelNeedsPassword = false;

  users.users.luca = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    hashedPassword = "$6$BZKOzqbNgj8F2JDm$KVpnMK1inaM0tnHSw6dIlA1oZ7sT/j7RQL4u5wa9RHYeHcqEFILTqi0HGKCYIwhCEWuJIhBv3h.tjSCZ/j6yw/";
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    k3s
    git
    helmfile
    kubernetes-helm
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";

}
