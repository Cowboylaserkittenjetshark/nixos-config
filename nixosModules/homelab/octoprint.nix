{
  lib,
  lib',
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.homelab) domain backend;
  inherit (backend) enable vpnAccess;
  opCfg = config.services.octoprint;
  opDomain = "octoprint.${domain}";
in
{
  config = mkIf enable {
    services = {
      octoprint = {
        enable = true;
        host = "127.0.0.1";
        plugins =
          plugins: with plugins; [
            printtimegenius
            simpleemergencystop
            themeify
            titlestatus
          ];
      };

      caddy.virtualHosts = lib'.caddy.site "${opDomain}" ''
        import localOnly
        reverse_proxy ${opCfg.host}:${toString opCfg.port}
      '';
    };

    networking = {
      hosts."${opCfg.host}" = [ "${opDomain}" ];
      firewall.interfaces = mkIf vpnAccess.enable {
        ${vpnAccess.interface}.allowedTCPPorts = [ opCfg.port ];
      };
    };
  };
}
