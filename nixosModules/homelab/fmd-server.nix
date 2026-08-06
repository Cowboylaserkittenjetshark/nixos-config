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
        Restart = "on-failure";
        DynamicUser = true;
        StateDirectory = "fmd-server";
        Environment = [
          "FMD_PORTINSECURE=${toString cfg.port}"
          "FMD_DATABASEDIR=/var/lib/fmd-server/db/"
        ];
        EnvironmentFile = cfg.environmentFile;
        UMask = "0077";
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        SocketBindDeny = ["ipv4:udp" "ipv6:udp"];
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "CAP_BPF"
          "CAP_CHOWN"
          "CAP_IPC_LOCK"
          "CAP_KILL"
          "CAP_MKNOD"
          "CAP_NET_RAW"
          "CAP_PERFMON"
          "CAP_SYS_BOOT"
          "CAP_SYS_CHROOT"
          "CAP_SYS_MODULE"
          "CAP_SYS_NICE"
          "CAP_SYS_PACCT"
          "CAP_SYS_PTRACE"
          "CAP_SYS_TIME"
          "CAP_SYS_TTY_CONFIG"
          "CAP_SYSLOG"
          "CAP_WAKE_ALARM"
        ];
        SystemCallFilter = [
          "~@aio:EPERM"
          "@chown:EPERM"
          "@clock:EPERM"
          "@cpu-emulation:EPERM"
          "@debug:EPERM"
          "@ipc:EPERM"
          "@keyring:EPERM"
          "@memlock:EPERM"
          "@module:EPERM"
          "@mount:EPERM"
          "@obsolete:EPERM"
          "@pkey:EPERM"
          "@privileged:EPERM"
          "@raw-io:EPERM"
          "@reboot:EPERM"
          "@resources:EPERM"
          "@sandbox:EPERM"
          "@setuid:EPERM"
          "@swap:EPERM"
        ];
      };
    };

    networking.hosts."127.0.0.1" = [ "${cfg.subDomain}.${domain}" ];

    age.secrets.fmd-server-environment = {
      file = ../../secrets/fmd-server-environment.age;
      mode = "400";
    };
  };
}
