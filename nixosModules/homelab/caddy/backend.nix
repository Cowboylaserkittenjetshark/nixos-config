{ lib, config, ... }: let
  inherit (config.homelab) frontend domain;
in {
  config = lib.mkIf frontend.enable {
    services.caddy = {
      globalConfig = ''
        servers {
          # Trust frontend caddy
          trusted_proxies static ${frontend.address}
        }
        # Contains `acme_dns cloudflare <token>`
        import ${config.age.secrets.caddy-cloudflare-dns.path}
      '';
      extraConfig = ''
        # Use https://caddyserver.com/docs/caddyfile/matchers#client-ip to block traffic from cloudflared
        # It's remote_ip is in private_ranges (127.0.0.1), so the remote_ip matcher cannot be used
        (localOnly) {
          @notPrivate not client_ip private_ranges 100.64.0.0/10
          abort @notPrivate
        }
      '';
      virtualHosts = {
        "*.${domain}".extraConfig = ''
          abort
        '';
        "${domain}".extraConfig = ''
          root * /srv/caddy/
          encode zstd gzip
          file_server
        '';
      };
    };
  };
}
