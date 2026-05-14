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
    getExe
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
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';

    systemd.services."fmd-server" = {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe cfg.package} serve";
        Environment = "FMD_PORTINSECURE=${toString cfg.port}";
        EnvironmentFile = cfg.environmentFile;
      };
    };
    
    networking.hosts."127.0.0.1" = ["${cfg.subDomain}.${domain}"];

    age.secrets.fmd-server-environment = {
      file = ../../secrets/fmd-server-environment.age;
      mode = "400";
    };
  };
}
