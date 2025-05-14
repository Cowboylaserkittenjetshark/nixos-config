{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe getExe';
in
{
  systemd.user = {
    timers.cliphist-clear = {
      Unit.Description = "Clear clipboard history";
      Timer.OnUnitActiveSec = "10min";
      Install.WantedBy = [ "graphical-session.target" ];
    };
    services = {
      cliphist-image = {
        Unit = {
          Description = "Clipboard history for wayland";
          BindsTo = "graphical-session.target";
          PartOf = "graphical-session.target";
          After = "graphical-session.target";
          Requisite = "graphical-session.target";
        };
        Service = {
          Type = "exec";
          ExecStart = "${getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch ${getExe pkgs.cliphist} store";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      cliphist-text = {
        Unit = {
          Description = "Clipboard history for wayland";
          BindsTo = "graphical-session.target";
          PartOf = "graphical-session.target";
          After = "graphical-session.target";
          Requisite = "graphical-session.target";
        };
        Service = {
          Type = "exec";
          ExecStart = "${getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch ${getExe pkgs.cliphist} store";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      clip-persist = {
        Unit = {
          Description = "Clipboard persistance daemon for wayland";
          BindsTo = "graphical-session.target";
          PartOf = "graphical-session.target";
          After = "graphical-session.target";
          Requisite = "graphical-session.target";
        };
        Service = {
          Type = "exec";
          ExecStart = "${getExe pkgs.wl-clip-persist} --clipboard regular";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
      cliphist-clear = {
        Unit.Description = "Clear clipboard history";
        Service = {
          Type = "oneshot";
          ExecStart = "${getExe' pkgs.cliphist "cliphist"} wipe";
        };
      };
    };
  };

  home.packages = with pkgs; [
    cliphist
    wl-clipboard
  ];
}
