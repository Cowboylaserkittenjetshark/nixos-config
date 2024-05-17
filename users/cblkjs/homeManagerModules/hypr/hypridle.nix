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
      general = {
        lock_cmd = "pidof hyprlock || ${hyprlock}";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${hyprctl} dispatch dpms on";
      };

      listener = [
        {
          timeout = 120;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 150;
          on-timeout = "${hyprctl} dispatch dpms off";
          on-resume = "${hyprctl} dispatch dpms on";
        }
      ];
    };
  };
}
