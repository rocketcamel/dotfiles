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
    bind -n M-h previous-window
    bind -n M-l next-window
  '';
  escapeTime = 0;
}
