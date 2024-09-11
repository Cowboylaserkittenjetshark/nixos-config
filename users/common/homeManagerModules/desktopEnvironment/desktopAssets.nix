{config, osConfig, lib, ...}: let
  inherit (lib) mkOption types;
  inherit (osConfig.desktopAssets) wallpaper lockscreen;
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
  config = {
    xdg.configFile = {
      "wallpaper".source = wallpaper;
      "lockscreen".source = lockscreen;
    };
    desktopAssets = {
      wallpaper = "${config.home.homeDirectory}/${config.xdg.configFile."wallpaper".target}";
      lockscreen = "${config.home.homeDirectory}/${config.xdg.configFile."lockscreen".target}";
    };
  };
}
