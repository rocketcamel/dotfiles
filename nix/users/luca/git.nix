{
  enable = true;
  userName = "rocketcamel";
  userEmail = "luca_lise@icloud.com";
  extraConfig = {
    init = {
      defaultBranch = "main";
    };
    commit.gpgsign = true;
    gpg.format = "ssh";
    user.signingkey = "~/.ssh/commits.id_rsa.pub";
  };
}
