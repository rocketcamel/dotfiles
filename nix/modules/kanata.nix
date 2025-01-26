{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.kanata = {
    enable = lib.mkEnableOption "enable kanata";
  };

  config = lib.mkIf config.kanata.enable {
    services.kanata.enable = true;
    services.kanata.keyboards.main = {
      config = ''
        (defsrc
          caps
        )

        (defalias
          caps-mod esc
        )

        (deflayer base
          @caps-mod
        )
      '';
      extraDefCfg = "process-unmapped-keys yes";
    };
  };
}
