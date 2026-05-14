{ config, lib, pkgs, ...  }: let
  inherit (config.homelab) domain enable;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.services.rooted-graphene;
  rooted-ota = lib.getExe (pkgs.callPackage ../../pkgs/rooted-graphene { });
in {
  options.homelab.rooted-graphene= {
    enable = mkEnableOption "custom OTA update server for GrapheneOS";
  };
  config = mkIf enable {
    services.caddy.virtualHosts."ota.${domain}".extraConfig = ''
      root /srv/caddy/rooted-graphene/
      file_server browse
    '';

    systemd = {
      timers."rooted-ota" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "05:00:00 America/New_York";
          Unit = "rooted-ota.service";
        };
      };

      services."rooted-ota" = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = rooted-ota;
          RemainAfterExit = true; # Prevents the service from automatically starting on rebuild. See https://discourse.nixos.org/t/how-to-prevent-custom-systemd-service-from-restarting-on-nixos-rebuild-switch/43431
          DynamicUser = true;
          SupplementaryGroups = "docker";
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          SystemCallFilter = "~@clock @cpu-emulation @debug @obsolete @module @mount @raw-io @reboot @swap";
          ProtectControlGroups = true;
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };
      };
    };
  };
}
