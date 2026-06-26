{ lib, lib', config, ... }: let
  inherit (config.homelab) frontend backend domain;
  inherit (lib'.caddy) site;
in {
  config = lib.mkIf backend.enable {
    services.caddy = {
      globalConfig = ''
        servers {
          # Trust frontend caddy
          trusted_proxies static ${frontend.address}
        }
      '';
      extraConfig = ''
        # Use https://caddyserver.com/docs/caddyfile/matchers#client-ip to block traffic from cloudflared
        # It's remote_ip is in private_ranges (127.0.0.1), so the remote_ip matcher cannot be used
        (localOnly) {
          @notPrivate not client_ip private_ranges 100.64.0.0/10
          abort @notPrivate
        }
      '';
      virtualHosts = site "*.${domain}" "abort" // 
        site "${domain}" ''
          root * /srv/caddy/
          encode zstd gzip
          file_server
        '';
    };
  };
}
