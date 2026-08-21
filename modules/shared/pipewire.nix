{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.services.pipewire.enable {
    environment.systemPackages = with pkgs; [
      pamixer
    ];
  };
}
