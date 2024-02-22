{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  # hyprlock = lib.getExe config.programs.hyprlock.package;
  hyprlock = lib.getExe inputs.hyprlock.packages.${pkgs.system}.hyprlock;
  hyprctl = inputs.hyprland.packages.${pkgs.system}.hyprland + "/bin/hyprctl";
in {
  imports = [
    inputs.hypridle.homeManagerModules.hypridle
  ];

  services.hypridle = {
    enable = true;
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
}
