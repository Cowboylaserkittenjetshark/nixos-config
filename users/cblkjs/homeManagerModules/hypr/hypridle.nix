{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  hyprlock = lib.getExe config.programs.hyprlock.package;
  hyprctl = inputs.hyprland.packages.${pkgs.system}.hyprland + "/bin/hyprctl";
in {
  services.hypridle = {
    enable = true;
    settings = {
      lockCmd = "${hyprlock}";
      listeners = [
        {
          timeout = 120;
          onTimeout = "${hyprlock}";
          onResume = "";
        }
        {
          timeout = 150;
          onTimeout = "${hyprctl} dispatch dpms off";
          onResume = "${hyprctl} dispatch dpms on";
        }
      ];
    };
  };
}
