{
  enable = true;
  userName = "rocketcamel";
  userEmail = "luca_lise@icloud.com";
  signing = {
    signByDefault = true;
    format = "ssh";
    key = "~/.ssh/commits.id_ed25519.pub";
  };
  extraConfig = {
    init = {
      defaultBranch = "main";
    };
    push = {
      autoSetupRemote = true;
    };
  };
}
