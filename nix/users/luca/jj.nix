{
  enable = true;
  settings = {
    user = {
      email = "luca_lise@icloud.com";
      name = "lucalise";
    };
    ui = {
      pager = "less -FRX";
      default-command = "log";
      diff.format = "git";
    };
    signing = {
      behavior = "own";
      backend = "ssh";
      key = "~/.ssh/id_ed25519.pub";
    };
  };
}
