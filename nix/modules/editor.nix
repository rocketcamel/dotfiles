{
  config,
  lib,
  pkgs,
  meta,
  ...
}:
{
  options.editor = {
    enable = lib.mkOption {
      default = config.desktop.enable;
      description = "enable editor";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.editor.enable {
    home-manager.users.luca = {
      programs.zed-editor = {
        enable = true;
        extraPackages = with pkgs; [
          nixd
        ];
      };
    };
  };
}
