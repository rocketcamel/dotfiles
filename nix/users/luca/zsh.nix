{
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  envExtra = ''
    EDITOR=nvim
    . "$HOME/.rokit/env"
    eval "$(oh-my-posh init zsh -c ~/.config/ohmyposh/zen.toml)"
  '';
}
