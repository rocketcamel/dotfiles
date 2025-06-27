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

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    efiInstallAsRemovable = true;
  };
  networking.hostName = meta.hostname;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    videoAcceleration = true;
  };

  time.timeZone = "America/Vancouver";

  i18n.defaultLocale = "en_US.UTF-8";
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  desktop.enable = true;
  kanata.enable = true;
  users.users.luca = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
    hashedPassword = config.hashedPassword;
    openssh.authorizedKeys.keys = config.authorized_ssh;
  };

  hardware.graphics.enable = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  services.flatpak.enable = true;
  environment.systemPackages =
    with pkgs;
    config.commonPackages
    ++ [
    ];

  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
