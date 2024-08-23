{lib, ...}: let
  inherit (lib) mkOption types;
in {
  options.desktopAssets = {
    wallpaper = mkOption {
      type = types.path;
      description = ''
        Path to a wallpaper image to use.
      '';
    };
    lockscreen = mkOption {
      type = types.path;
      description = ''
        Path to a lockscreen image to use.
      '';
    };
  };
}
