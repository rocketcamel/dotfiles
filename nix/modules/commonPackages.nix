{ pkgs, lib, ... }:
{
  options = {
    commonPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Common packages";
    };
  };
  config = {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      roboto
      roboto-mono
      open-sans
    ];
    fonts.fontDir.enable = true;
    commonPackages = with pkgs; [
      wget
      busybox
      curl
      stow
      gh
      neovim
      ripgrep
      git
      gcc
      nixfmt-rfc-style
      asciiquarium
      wireguard-tools
      fzf
      awscli2
      # deno
      jq
      nfs-utils
      bluetui
      go
      templ
      bun
      air
      tailwindcss_4
      gnumake
      watchman
      bat
      rustup
      emote
      pkg-config
      openssl
      gnupg
      nixd
      sops
      yubikey-personalization
      yubikey-manager
      gnupg
      (pass.withExtensions (exts: with exts; [ pass-import ]))
      python3
      jdt-language-server
      gradle
    ];
    programs.nix-ld.enable = lib.mkDefault true;
    programs.zsh.enable = lib.mkDefault true;
    services.openssh.enable = lib.mkDefault true;
    hardware.enableAllFirmware = true;
    sops.defaultSopsFile = ../../secrets/sops.yaml;
    sops.age.sshKeyPaths = [ "/etc/ssh/id_ed25519" ];
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
    };
    services.pcscd.enable = true;
    services.udev.packages = with pkgs; [ yubikey-personalization ];

    programs.neovim = lib.mkDefault {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
