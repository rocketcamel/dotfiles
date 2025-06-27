{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.kanata = {
    enable = lib.mkEnableOption "enable kanata";
    apple = lib.mkEnableOption "enable apple";
  };

  config = lib.mkIf config.kanata.enable {
    services.kanata.enable = true;
    services.kanata.keyboards =
      if !config.kanata.apple then
        {
          main = {
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
        }
      else
        {
          main = {
            config = ''
              (defsrc
                caps
                lalt
                lmet
              )

              (defalias
                caps-mod esc
                alt-mod lmet
                met-mod lalt
              )

              (deflayer base
                @caps-mod
                @alt-mod
                @met-mod
              )
            '';
          };
        };
  };
}
