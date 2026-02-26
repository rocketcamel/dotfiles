{
  pkgs,
  pkgs-before,
  inputs,
  meta,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.desktop.enable {
    environment.systemPackages = with pkgs; [
      vscode-fhs
      pavucontrol
      vlc
      wine64
      firefox
      brightnessctl
      pkgs-before.jellyfin-media-player
      anki-bin
      mpv
      prismlauncher
      dconf
      papirus-icon-theme
      libnotify
      adwaita-icon-theme
      gnome-themes-extra
      wl-clipboard
      wl-clip-persist
      wdisplays
      efibootmgr
      xfce.thunar
      xdg-desktop-portal
      microsoft-edge
      libadwaita
      grim
      grimblast
      slurp
      swappy
      fanctl
      waypipe
      inputs.quickshell.packages.${meta.architecture}.default
      alacritty
    ];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    programs.steam.enable = true;
    programs.obs-studio.enable = true;

    rofi.enable = true;
    zed.enable = true;
    virt.enable = true;
    printing.enable = true;

    home-manager.users.luca = {
      home.packages = with pkgs; [
        webcord
        blueberry
      ];
      programs = {
        ghostty = {
          enable = true;
          settings = {
            "shell-integration-features" = "no-cursor";
            "background-opacity" = 0.85;
            "cursor-style" = "block";
            "cursor-style-blink" = false;
            "font-size" = 15;
          };
        };
        hyprlock = {
          enable = true;
        };
        ranger.enable = true;
      };
    };
  };
}
