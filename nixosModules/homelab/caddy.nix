{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.homelab) domain enable;
  inherit (lib) mkIf;
  plugins = {
    plugins = [ "github.com/caddy-dns/cloudflare@v0.2.1" "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb" ];
    hash = "sha256-V92nzVrL7cZmUk+ShHnNZE6GszU7fv8Nw9O+LMJSaZQ=";
  };
in
{
  config = mkIf enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins plugins;
      globalConfig = ''
        servers {
          # Trust cloudflared
          trusted_proxies static 127.0.0.1
        }
        # Contains `acme_dns cloudflare <token>`
        import ${config.age.secrets.caddy-cloudflare-dns.path}
      '';
      extraConfig = ''
        # Use https://caddyserver.com/docs/caddyfile/matchers#client-ip to block traffic from cloudflared
        # It's remote_ip is in private_ranges (127.0.0.1), so the remote_ip matcher cannot be used
        (localOnly) {
          @notPrivate not client_ip private_ranges 100.0.0.0/8
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
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    age.secrets.caddy-cloudflare-dns = {
      file = ../../secrets/caddy-cloudflare-dns.age;
      mode = "400";
      owner = "caddy";
      group = "caddy";
    };
  };
}
