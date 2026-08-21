{
  pkgs,
  meta,
  ...
}:
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
    ];
  };

  programs.vscodium = {
    enable = true;

    profiles.default = {
      extensions =
        (with pkgs.vscode-extensions; [
          rust-lang.rust-analyzer
          jnoortheen.nix-ide
          mvllow.rose-pine
          vscodevim.vim
          usernamehw.errorlens
          bradlc.vscode-tailwindcss
          tombi-toml.tombi
        ])
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "luau-lsp";
            publisher = "JohnnyMorganz";
            version = "1.68.1";
            sha256 = "sha256-WwyLMzIvVJo1r7x7cs2XIwe6WCx0eIWTzc8gbfvA/KU=";
          }
          {
            name = "stylua";
            publisher = "JohnnyMorganz";
            version = "1.7.2";
            sha256 = "sha256-l/znKp+myNqS8RYVAyBGn5Up9LfXs0HPUr1ZrV4CrKE=";
          }
        ];

      keybindings = [
        {
          key = "shift+d";
          command = "deleteFile";
          when = "filesExplorerFocus && !inputFocus";
        }
        {
          key = "a";
          command = "explorer.newFile";
          when = "filesExplorerFocus && !inputFocus";
        }
      ];

      userSettings = {
        "vim.leader" = "<space>";
        "vim.useSystemClipboard" = true;
        "security.workspace.trust.enabled" = false;

        "workbench.colorTheme" = "Rosé Pine (no italics)";
        "editor.inlayHints.enabled" = "offUnlessPressed";
        "editor.lineNumbers" = "relative";
        "editor.formatOnSave" = true;
        "editor.cursorBlinking" = "solid";
        "editor.fontSize" = 15;

        "vim.cursorStylePerMode" = {
          insert = "block";
        };

        "luau-lsp.fflags.enableNewSolver" = true;
        "rust-analyzer.lens.implementations.enable" = false;
        "tailwindCSS.includeLanguages" = {
          rust = "html";
        };

        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            before = "<C-p>";
            commands = [ "workbench.action.quickOpen" ];
          }
          {
            before = [ "K" ];
            commands = [ "editor.action.showHover" ];
          }
          {
            before = [
              "g"
              "r"
              "n"
            ];
            commands = [ "editor.action.rename" ];
          }
          {
            before = [
              "<leader>"
              "f"
              "g"
            ];
            commands = [ "search.action.openNewEditor" ];
          }
          {
            before = [
              "<leader>"
              "e"
            ];
            commands = [ "workbench.action.toggleSidebarVisibility" ];
          }
        ];

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          nil = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };

          nixd = {
            formatting = {
              command = [ "nixfmt" ];
            };

            options = {
              nixos = {
                expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${meta.hostname}.options";
              };
              home-manager = {
                expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${meta.hostname}.options.home-manager.users.type.getSubOptions []";
              };
            };

          };
        };
      };
    };
  };
}
