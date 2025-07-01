{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.zed = {
    enable = lib.mkEnableOption "enable zed";
  };

  config = lib.mkIf config.zed.enable {
    home-manager.users.luca = {
      programs.zed-editor = {
        enable = true;
        extraPackages = with pkgs; [ nixd ];
        extensions = [
          "luau"
          "nix"
          "rose-pine-theme"
        ];
        userSettings = {
          features = {
            edit_prediction_provider = "none";
          };
          edit_predictions = null;
          vim_mode = true;
          ui_font_size = 16;
          buffer_font_size = 16;
          relative_line_numbers = true;
          git.inline_blame = {
            enabled = false;
          };
          theme = {
            mode = "system";
            light = "Rosé Pine";
            dark = "Rosé Pine";
          };
          diagnostics = {
            inline = {
              enabled = true;
            };
          };
          format_on_save = "on";
          lsp = {
            "luau-lsp" = {
              settings = {
                luau-lsp = {
                  completion = {
                    imports = {
                      enabled = true;
                      suggestRequires = true;
                      suggestServices = true;
                    };
                  };
                };
                ext = {
                  roblox = {
                    enabled = true;
                    security_level = "plugin";
                  };
                  fflags = {
                    enable_new_solver = true;
                    sync = true;
                  };
                };
              };
            };
            nixd = {
              initialization_options = {
                formatting = {
                  command = [
                    "nixfmt"
                    "--quiet"
                    "--"
                  ];
                };
              };
            };
          };
          languages = {
            Luau = {
              formatter = {
                external = {
                  command = "stylua";
                  arguments = [ "-" ];
                };
              };
            };
            Nix = {
              language_servers = [ "nixd" ];
            };
          };
        };
      };
    };
  };
}
