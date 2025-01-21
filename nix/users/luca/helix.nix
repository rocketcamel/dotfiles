{ pkgs, ... }:

{
  enable = true;
  languages.language = [
    {
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
    }
    {
      name = "typescript";
      auto-format = true;
      formatter = {
        command = "${pkgs.nodePackages_latest.prettier}/bin/prettier";
        args = [ "--parser" "typescript" ];
      };
    }
    {
      name = "tsx";
      auto-format = true;
      formatter = {
        command = "${pkgs.nodePackages_latest.prettier}/bin/prettier";
        args = [ "--parser" "typescript" ];
      };
    }
  ];
  settings = {
    theme = "rose_pine";
    editor = {
      true-color = true;
      line-number = "relative";
      lsp.display-messages = true;
      cursor-shape = {
        insert = "block";
        normal = "block";
      };
    };
    keys.normal = {
      space.q = ":q";
      w = [ "move_next_word_start" "move_char_right" "collapse_selection" ];
      b = [ "move_prev_word_start" "collapse_selection" ];
      i = [ "insert_mode" "collapse_selection" ];
      a = [ "append_mode" "collapse_selection" ];
    };
  };
  themes = {
    rose_pine = {
      inherits = "rose_pine";
      "ui.background" = "transparent";
    };
  };
}
