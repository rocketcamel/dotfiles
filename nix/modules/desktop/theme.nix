{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    home-manager.users.luca = {
      gtk = {
        enable = true;
        theme.name = "Adwaita-dark";
        colorScheme = "dark";
      };
      qt = {
        enable = true;
        style.name = "adwaita-dark";
      };
      home.pointerCursor = {
        name = "Adwaita";
        size = 24;
        gtk.enable = true;
        package = pkgs.gnome-themes-extra;
      };
    };
  };
}
