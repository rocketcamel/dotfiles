{ config, pkgs, meta, ... }: {
  networking.hostName = meta.hostname;

  services.openssh = {
    enable = true;
  };

  users.users.luca = {
    name = "luca";
    home = "/Users/luca";
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; config.common_packages ++ [];

  system.stateVersion = 7;
}
