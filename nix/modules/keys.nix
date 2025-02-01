{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    authorized_ssh = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBIvu/oh6LiuRvrluMV1hStvgdg0x1KNWnNxlR26zer75z2dEQcyou54uTyqJ0hbQXRTaolD5GxAoCc0HdPMkXiZJYPyMl65mVxyFWreXgFNSAAx5z/3D7B23qGNOBcc8mIiDwcNL5gKCzm5kHlRp9XY+VMTc8i89Abj3eo3pubcw2P8u8kmNgkswHrcwTjCDP6MBVkE0LwoamhB/KrpnYJrqsoBcOljhlKh6w9EBGcZPYBA1tg555IywZ89B4Kty5/0ydaO3E/qpr8lXfVRrhA7JRzeuUfnkXJLJetmwLT28O5fn+swzwdMM3TUbtL73ncGaLHR0/cpeTSgVxAV9KLMJIhS9EULlz9Fk79nWZ0w+JHjzVbmwWXA9GABMr1OgfksqNhs/FDQeyMYTf8+o7lGKtl1eHmD3TuuENIAIrq3RvIY5Q8O4xpioWZA9mZ3bLkp1EBowT6z059iDoxTw0fRWmegEXpSvbleXH7So68W72YJo200IXcwfizfwTsPE= luca@DESKTOP-G36D6AR"
      ];
    };
    hashedPassword = lib.mkOption {
      type = lib.types.str;
      default = "$y$j9T$wp9I05TfxjrAzCMCcxlei1$Fm7sJJSwFHpSIQT0RESOdJ7vkTYyN0IXs5n/xkg65y3";
    };
  };
}
