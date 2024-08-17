{
  lib,
  config,
  ...
}: let
  inherit (config.homelab) domain enable;
in {
  config = lib.mkIf enable {
    services.cloudflared = {
      enable = true;
      tunnels.container-stack = {
        credentialsFile = "/etc/cloudflared/container-stack.json";
        default = "http_status:404";
        ingress = {
          "${domain}".service = "https://127.0.0.1";
          "*.${domain}".service = "https://127.0.0.1";
        };
        originRequest = {
          originServerName = config.homelab.domain;
        };
      };
    };
  };
}
