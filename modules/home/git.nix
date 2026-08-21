{
  enable = true;
  settings = {
    user = {
      name = "lucalise";
      email = "luca_lise@icloud.com";
    };
    init = {
      defaultBranch = "main";
    };
    push = {
      autoSetupRemote = true;
    };
  };
  signing = {
    signByDefault = true;
    format = "ssh";
    key = "~/.ssh/id_ed25519.pub";
  };
}
