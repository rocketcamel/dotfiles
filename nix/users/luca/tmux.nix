{ pkgs, ... }:

{
  enable = true;
  prefix = "C-Space";
  mouse = true;
  baseIndex = 1;
  sensibleOnTop = true;
  keyMode = "vi";
  plugins = with pkgs; [ { plugin = tmuxPlugins.tokyo-night-tmux; } ];
  extraConfig = ''
    bind -n M-H previous-window
    bind -n M-L next-window
  '';
  escapeTime = 0;
}
