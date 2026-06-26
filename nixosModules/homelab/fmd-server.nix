{
  config,
  lib,
  lib',
  pkgs,
  ...
}:
let
  inherit (config.homelab) domain backend;
  inherit (backend) enable;
  inherit (lib)
    mkOption
    mkPackageOption
    mkEnableOption
    mkIf
    types
    getExe
    ;
  inherit (types) str path;
  cfg = config.homelab.fmd-server;
in
{
  options.homelab.fmd-server = {
    enable = mkEnableOption "a server to communicate with the FindMyDevice app and save the latest (encrypted) location";

    package = mkPackageOption pkgs "fmd-server" { };

    port = mkOption {
      type = types.port;
      default = 10210;
    };
    
    subDomain = mkOption {
      type = str;
      default = "fmd";
    };

    environmentFile = mkOption {
      type = path;
      default = config.age.secrets.fmd-server-environment.path;
    };

    dataDir = mkOption {
      type = path;
      default = "/var/lib/fmd-server";
    };

    user = mkOption {
      type = str;
      default = "fmd-server";
    };

    group = mkOption {
      type = str;
      default = "fmd-server";
    };

  };

  config = mkIf enable {
    services.caddy.virtualHosts = lib'.caddy.site "${cfg.subDomain}.${domain}" ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';

    systemd.services."fmd-server" = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe cfg.package} serve";
        Restart = "always";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;
        Environment = [
          "FMD_PORTINSECURE=${toString cfg.port}"
          "FMD_DATABASEDIR=${cfg.dataDir}"
        ];
        EnvironmentFile = cfg.environmentFile;

        # Hardening
        WorkingDirectory = cfg.dataDir;
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DeviceAllow = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateNetwork = false; # provides the service through network
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "noaccess";
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.dataDir ];
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        # SystemCallFilter = concatStringsSep " " [
        #   "~"
        #   "@clock"
        #   "@cpu-emulation"
        #   "@debug"
        #   "@module"
        #   "@mount"
        #   "@obsolete"
        #   "@privileged"
        #   "@raw-io"
        #   "@reboot"
        #   "@resources"
        #   "@swap"
        # ];
        UMask = "0077";
      };
    };
    
    networking.hosts."127.0.0.1" = ["${cfg.subDomain}.${domain}"];

    age.secrets.fmd-server-environment = {
      file = ../../secrets/fmd-server-environment.age;
      mode = "400";
    };
  };
}
