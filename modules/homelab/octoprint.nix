{
  lib,
  config,
  ...
}: let
  inherit (config.homelab) domain enable;
  opCfg = config.services.octoprint;
in {
  config = lib.mkIf enable {
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

      caddy.virtualHosts."octoprint.${domain}".extraConfig = ''
        import localOnly
        reverse_proxy ${opCfg.host}:${toString opCfg.port}
      '';
    };
  };
}
