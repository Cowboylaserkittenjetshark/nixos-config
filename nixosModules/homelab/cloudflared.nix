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
      tunnels.homelab = {
        credentialsFile = "/etc/cloudflared/homelab.json";
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
    systemd.services.cloudflared-tunnel-homelab.environment.TUNNEL_TRANSPORT_PROTOCOL = "http2";
  };
}
