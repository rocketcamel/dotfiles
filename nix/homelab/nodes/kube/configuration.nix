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

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/nvme0n1";
  };

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
    hashedPassword = config.hashedPassword;
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

  system.stateVersion = "25.11";

}
