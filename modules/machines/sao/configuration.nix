{ pkgs, meta, ... }: {
  networking.hostName = meta.hostname;

  services.openssh = {
    enable = true;
  };

  users.users.luca = {
    name = "luca";
    home = "/Users/luca";
    shell = pkgs.zsh;
  };

  system.stateVersion = 7;
}
