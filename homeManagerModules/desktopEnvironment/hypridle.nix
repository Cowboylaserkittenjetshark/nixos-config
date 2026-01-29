{
  lib,
  inputs,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.systemAttributes.graphical {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${lib.getExe osConfig.services.noctalia-shell.package} ipc call lockScreen lock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "niri msg action power-on-monitors";
        };

        listener = [
          {
            timeout = 120;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 150;
            on-timeout = "niri msg action power-off-monitors";
            on-resume = "niri msg action power-on-monitors";
          }
        ];
      };
    };
  };
}
