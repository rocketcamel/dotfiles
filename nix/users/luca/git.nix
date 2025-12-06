{
  enable = true;
  settings = {
    user = {
      name = "rocketcamel";
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
    key = "~/.ssh/commits.id_ed25519.pub";
  };
}
