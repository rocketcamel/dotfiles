{ pkgs, ... }:
let
  scripts = builtins.attrNames (builtins.readDir ../../../aliases);
  aliases = builtins.concatStringsSep "\n" (
    map (
      name:
      let
        aliasName = builtins.replaceStrings [ ".sh" ] [ "" ] name;
      in
      "alias ${aliasName}='~/dotfiles/aliases/${name}'"
    ) scripts
  );
in
{
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  history.size = 1000;
  envExtra =
    ''
      export PATH="$PATH:$HOME/.rokit/bin"
      export GOPATH="$HOME/go"
      export GOBIN="$HOME/go/bin"
      export PATH="$GOBIN:$PATH"
    ''
    + "\n"
    + aliases;
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
