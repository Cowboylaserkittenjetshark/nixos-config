{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.bazarr;
  inherit (lib) mkIf optionalString mkForce;
in
{
  config = mkIf cfg.enable {
    # Based on https://github.com/NixOS/nixpkgs/blob/9f918d616c5321ad374ae6cb5ea89c9e04bf3e58/nixos/modules/services/misc/bazarr.nix#L40-L58
    # and the upstream service at https://wiki.bazarr.media/Getting-Started/Autostart/Linux/linux/
    systemd.services.bazarr = mkForce {
      unitConfig = {
        Description = "Bazarr Daemon";
        After = [
          "syslog.target"
          "network.target"
          (optionalString config.services.sonarr.enable "sonarr.service")
          (optionalString config.services.radarr.enable "radarr.service")
        ];
      };

      serviceConfig = {
        WorkingDirectory = "/var/lib/bazarr";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0002";
        Restart = "on-failure";
        RestartSec = 5;
        Type = "simple";
        ExecStart = pkgs.writeShellScript "start-bazarr" ''
          ${pkgs.bazarr}/bin/bazarr \
            --config '/var/lib/bazarr' \
            --port ${toString cfg.listenPort} \
            --no-update True
        '';
        KillSignal = "SIGINT";
        TimeoutStopSec = 20;
        SyslogIdentifier = "bazarr";
        # ExecStartPre = "${pkgs.coreutils}/bin/sleep 30"; # Why tho?
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
