# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, home-manager, meta, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/default.nix
  ];

  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    efiInstallAsRemovable = true;
  };

  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = meta.hostname;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  hm.enable = true;
  i3.enable = true;
  kanata.enable = true;

  services.flatpak.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common = { default = [ "gtk" ]; };
  };

  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  hardware = { graphics.enable = true; };

  users.users.luca = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    hashedPassword =
      "$y$j9T$wp9I05TfxjrAzCMCcxlei1$Fm7sJJSwFHpSIQT0RESOdJ7vkTYyN0IXs5n/xkg65y3";
  };

  environment.systemPackages = with pkgs;
    config.commonPackages ++ [ dolphin wireguard-tools ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh.enable = true;

  system.stateVersion = "24.11";
}

