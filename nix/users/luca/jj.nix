{
  enable = true;
  settings = {
    user = {
      email = "luca@lucalise.ca";
      name = "lucalise";
    };
    ui = {
      pager = "less -FRX";
      default-command = "log";
      diff-formatter = "git";
    };
    signing = {
      behavior = "own";
      backend = "ssh";
      key = "~/.ssh/id_ed25519.pub";
    };
  };
}
