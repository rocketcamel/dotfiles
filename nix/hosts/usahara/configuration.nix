# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  meta,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  networking.hostName = meta.hostname;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  time.timeZone = "America/Vancouver";

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  desktop.enable = true;
  kanata.enable = true;
  kanata.apple = true;

  users.users.luca = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    hashedPassword = config.hashedPassword;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.authorized_ssh;
  };
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  home-manager.users.luca = {
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "main";
          profile.outputs = [
            {
              status = "enable";
              criteria = "HDMI-A-1";
              position = "1920,0";
              mode = "1920x1080";
              scale = 1.0;
            }
            {

              status = "enable";
              criteria = "DP-1";
              position = "0,0";
              mode = "1920x1080@144Hz";
              scale = 1.0;
            }
          ];
        }
      ];
    };
  };

  services.flatpak.enable = true;

  environment.systemPackages =
    with pkgs;
    config.commonPackages
    ++ [
    ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
