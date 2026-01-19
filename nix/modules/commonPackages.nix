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
      noto-fonts-color-emoji
      liberation_ttf
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      roboto
      roboto-mono
      open-sans
      comic-relief
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
      emote
      pkg-config
      openssl
      gnupg
      nixd
      sops
      yubikey-personalization
      yubikey-manager
      (pass.withExtensions (exts: with exts; [ pass-import ]))
      python3
      jdt-language-server
      gradle
      cmake
      doppler
      wayland
      wayland-protocols
      libxkbcommon
      udev
      alsa-lib
      waypipe
      tea
      kubectl
      kubernetes-helm
      helmfile
      jless
      fd
      dig
    ];
    programs.nix-ld.enable = lib.mkDefault true;
    programs.zsh.enable = lib.mkDefault true;
    services.openssh.enable = lib.mkDefault true;
    hardware.enableAllFirmware = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      pinentryPackage = pkgs.pinentry-gtk2;
    };
    services.pcscd.enable = true;
    services.udev.packages = with pkgs; [
      yubikey-personalization
      yubikey-manager
    ];
    programs.ssh.startAgent = true;

    programs.neovim = lib.mkDefault {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      age.sshKeyPaths = [ "/home/luca/.ssh/id_ed25519" ];
      secrets = {
        "pihole_password" = {
          owner = "luca";
        };
        "k3s_token" = {
          owner = "luca";
        };
      };
    };
  };
}
