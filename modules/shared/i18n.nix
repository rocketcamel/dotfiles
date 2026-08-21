{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.language = {
    enable = lib.mkEnableOption "enable i18n" // {
      default = true;
    };
  };

  config = lib.mkIf config.language.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
      };
    };
    environment.systemPackages = with pkgs; [
      gnome-frog
      tesseract
    ];
  };
}
