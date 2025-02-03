{ pkgs, ... }:
{
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  history.size = 1000;
  envExtra = ''
    . "$HOME/.rokit/env"
  '';
  oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
    ];
  };
  plugins = [
    {
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab;
      file = "share/fzf-tab/fzf-tab.plugin.zsh";
    }
  ];
}
