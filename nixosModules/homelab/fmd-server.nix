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
    mkPackageOption
    mkEnableOption
    mkIf
    types
    ;
  inherit (types) str;
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
      type = types.path;
      default = config.age.secrets.fmd-server-environment.path;
    };
  };

  config = mkIf enable {
    services.caddy.virtualHosts."${cfg.subDomain}.${domain}".extraConfig = ''
      import localOnly
      reverse_proxy 127.0.0.1:${cfg.port}
    '';

    systemd.services."fmd-server" = {
      serviceConfig = {
        Type = "simple";
        ExecStart = cfg.package;
        Environment = "FMD_PORTINSECURE=${cfg.port}";
        EnvironmentFile = cfg.environmentFile;
      };
    };

    age.secrets.fmd-server-environment = {
      file = ../../secrets/fmd-server-environment.age;
      mode = "400";
    };
  };
}
