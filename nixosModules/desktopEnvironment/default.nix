{ lib, pkgs, config, ... }: {
  imports = [
    ./greetd.nix
    ./niri.nix
  ];

  options.desktopEnvironment.enable = lib.mkEnableOption "a desktop environment and supporting apps";

  config = {
    hardware.logitech.wireless.enable = config.desktopEnvironment.enable;

    fonts = lib.mkIf config.desktopEnvironment.enable {
      enableDefaultPackages = true;
      packages = [ pkgs.sarasa-gothic ];
    };
  };
}
