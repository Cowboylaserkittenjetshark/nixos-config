{
  lib,
  config,
  osConfig,
  ...
}:
let
  hyprlock = lib.getExe config.programs.hyprlock.package;
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
in
{
  config = lib.mkIf osConfig.systemAttributes.graphical {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || ${hyprlock}";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = if osConfig.programs.hyprland.enable then "${hyprctl} dispatch dpms on" else "niri msg action power-on-monitors";
        };

        listener = [
          {
            timeout = 120;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 150;
            on-timeout = if osConfig.programs.hyprland.enable then "${hyprctl} dispatch dpms off" else "niri msg action power-off-monitors";
            on-resume = if osConfig.programs.hyprland.enable then "${hyprctl} dispatch dpms on" else "niri msg action power-on-monitors";
          }
        ];
      };
    };
  };
}
