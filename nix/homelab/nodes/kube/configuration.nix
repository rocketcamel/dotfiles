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

  time.timeZone = "America/Vancouver";

  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin"
  ];

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets.k3s_token.path;
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

  environment.systemPackages =
    with pkgs;
    config.commonPackages
    ++ [
    ];

  services.openssh.enable = true;

  system.stateVersion = "25.11";

}
