{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.virt = {
    enable = lib.mkEnableOption "enable virtualization";
  };

  config = lib.mkIf config.virt.enable {
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ "luca" ];
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };
  };
}
