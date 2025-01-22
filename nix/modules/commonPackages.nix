{ pkgs, lib, ... }: {
  options = {
    commonPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Common packages";
    };
  };
  config.commonPackages = with pkgs; [ wget busybox curl stow ];
}
