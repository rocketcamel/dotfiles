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
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
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
