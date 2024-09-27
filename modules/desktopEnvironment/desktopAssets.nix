{lib, config, ...}: let
  inherit (lib) mkOption types mkIf;
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
  config = mkIf config.systemAttributes.graphical {
    age.secrets.Forest-Kingdom-Dithered-Mocha.file = ../../secrets/Forest-Kingdom-Dithered-Mocha.age;
    age.secrets.Amusement-Park2-Dithered-Mocha.file = ../../secrets/Amusement-Park2-Dithered-Mocha.age;
  };
}
