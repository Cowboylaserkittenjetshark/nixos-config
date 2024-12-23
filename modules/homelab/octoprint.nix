{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.homelab) domain enable;
  opCfg = config.services.octoprint;
  opDomain = "octoprint.${domain}";
in {
  config = mkIf enable {
    services = {
      octoprint = {
        enable = true;
        host = "127.0.0.1";
        plugins = plugins:
          with plugins; [
            printtimegenius
            simpleemergencystop
            themeify
            titlestatus
          ];
      };

      caddy.virtualHosts."${opDomain}".extraConfig = ''
        import localOnly
        reverse_proxy ${opCfg.host}:${toString opCfg.port}
      '';
    };

    networking = {
      hosts."${opCfg.host}" = ["${opDomain}"];
      firewall.interfaces = mkIf config.homelab.vpnAccess.enable {${config.homelab.vpnAccess.interface}.allowedTCPPorts = opCfg.port;};
    };
  };
}
