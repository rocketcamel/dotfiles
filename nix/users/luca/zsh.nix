{ pkgs, ... }:
{
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  history.size = 1000;
  envExtra = ''
    export PATH="$PATH:$HOME/.rokit/bin"
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
