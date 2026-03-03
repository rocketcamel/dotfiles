{ lib, config, ... }:
{
  config = lib.mkIf config.niri-desktop.enable {
    home-manager.users.luca = {
      services = {
        hyprpaper = {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;
            preload = [ "~/dotfiles/.config/wallpaper/bg.jpg" ];
            wallpaper = [
              ",~/dotfiles/.config/wallpaper/bg.jpg"
            ];
          };
        };
      };
    };
  };
}
