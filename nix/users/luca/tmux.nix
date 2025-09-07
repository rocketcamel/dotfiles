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
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R

  '';
  escapeTime = 0;
}
