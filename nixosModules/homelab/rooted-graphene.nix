{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.homelab) domain enable;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;
  inherit (types) str;
  cfg = config.homelab.rooted-graphene;
  rooted-ota = lib.getExe (pkgs.callPackage ../../pkgs/rooted-graphene { });
in
{
  options.homelab.rooted-graphene = {
    enable = mkEnableOption "custom OTA update server for GrapheneOS";

    deviceId = mkOption {
      type = str;
      default = "panther";
    };

    magiskPreinitDevice = mkOption {
      type = str;
      default = "sda8";
    };

    assetsDirectory = mkOption {
      type = str;
      default = "/srv/caddy/rooted-graphene";
    };

    subDomain = mkOption {
      type = str;
      default = "ota";
    };

    environmentFile = mkOption {
      type = types.path;
      default = config.age.secrets.rooted-graphene-environment.path;
    };

    user = mkOption {
      type = str;
      default = "rooted-graphene";
    };

    group = mkOption {
      type = str;
      default = "rooted-graphene";
    };
  };

  config = mkIf enable {
    services.caddy.virtualHosts."${cfg.subDomain}.${domain}".extraConfig = ''
      root ${cfg.assetsDirectory}
      file_server
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
        script = ''
          rm -rf ${cfg.assetsDirectory}
          rm -rf /tmp/rooted-graphene
          ${lib.getExe pkgs.git} clone https://github.com/schnatterer/rooted-graphene.git /tmp/rooted-graphene
          cd /tmp/rooted-graphene
          ${lib.getExe pkgs.git} status
          ${rooted-ota}
          cd /tmp
          rm -rf /tmp/rooted-graphene
        '';
        serviceConfig = {
          Type = "oneshot";
          WorkingDirectory = "/tmp";
          RemainAfterExit = true; # Prevents the service from automatically starting on rebuild. See https://discourse.nixos.org/t/how-to-prevent-custom-systemd-service-from-restarting-on-nixos-rebuild-switch/43431
          Environment = [
            "DEVICE_ID=${cfg.deviceId}"
            "MAGISK_PREINIT_DEVICE=${cfg.magiskPreinitDevice}"
            "SRV_DIRECTORY=${cfg.assetsDirectory}"
            "DOMAIN_NAME=${cfg.subDomain}.${domain}"
          ];
          EnvironmentFile = cfg.environmentFile;
        };
      };
    };

    age.secrets.rooted-graphene-environment = {
      file = ../../secrets/rooted-graphene-environment.age;
      mode = "400";
    };
  };
}
