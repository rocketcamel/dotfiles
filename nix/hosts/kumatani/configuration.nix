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
    useOSProber = true;
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

  i18n.defaultLocale = "en_US.UTF-8";
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  desktop.enable = false;
  niri-desktop.enable = true;
  kanata.enable = true;
  kanata.apple = true;

  users.users.luca = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
    hashedPassword = config.hashedPassword;
    openssh.authorizedKeys.keys = config.authorized_ssh;
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
              criteria = "DP-2";
              position = "0,0";
              mode = "1920x1080";
              scale = 1.0;
            }
            {

              status = "enable";
              criteria = "HDMI-A-1";
              position = "1920,0";
              mode = "3440x1440";
              scale = 1.0;
            }
          ];
        }
      ];
    };
  };

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia-container-toolkit.enable = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = config.sops.secrets.k3s_token.path;
    serverAddr = "https://192.168.27.11:6443";
    extraFlags = [
      "--node-label=gpu=nvidia"
      "--node-taint=graphics=true:NoSchedule"
    ];
  };
  networking.firewall = {
    allowedTCPPorts = [
      6443
      10250
    ];
    allowedUDPPorts = [ 8472 ];
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
