{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.printing = {
    enable = lib.mkEnableOption "enable printing";
  };

  config = lib.mkIf config.printing.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        hplip
        splix
        samsung-unified-linux-driver
        brlaser
      ];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
