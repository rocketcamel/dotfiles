{
  pkgs,
  inputs,
  meta,
  ...
}:
{
  imports = [
    ./notifications.nix
  ];

  home.packages = with pkgs; [
    blueman
    inputs.matugen.packages.${meta.architecture}.default
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
        "theme" = "Matugen";
      };
    };
    hyprlock = {
      enable = true;
    };
    ranger.enable = true;
    obsidian.enable = true;
  };

  services = {
    hyprpolkitagent.enable = true;
    cliphist.enable = true;
    awww.enable = true;
    gammastep = {
      enable = true;
      provider = "manual";
      latitude = 49.28;
      longitude = -123.12;
      temperature = {
        day = 6500;
        night = 3500;
      };
    };
  };

  xdg.mimeApps = import ./mime.nix;
  xdg.configFile = {
    "hypr/hyprlock.conf".source = ../../../custom/hyprlock/hyprlock.conf;
  };
}
