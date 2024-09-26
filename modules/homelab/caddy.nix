{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (config.homelab) domain enable;
  inherit (lib) mkIf warnIfNot versionAtLeast;
  customCaddyPkg = inputs.custom-caddy.packages.${pkgs.system}.default;
  defaultCaddyPkg = pkgs.caddy;
in {
  config = mkIf enable {
    services.caddy = {
      enable = true;
      package =
        warnIfNot
        (versionAtLeast customCaddyPkg.version defaultCaddyPkg.version)
        ''          The version of Caddy in the package is older than the version in your version of nixpkgs
                      Caddy from nixpkgs:  ${defaultCaddyPkg.version}
                      Caddy form nixcaddy: ${customCaddyPkg.version}
        ''
        customCaddyPkg;
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
    networking.firewall.allowedTCPPorts = [80 443];
    age.secrets.caddy-cloudflare-dns = {
      file = ../../secrets/caddy-cloudflare-dns.age;
      mode = "400";
      owner = "caddy";
      group = "caddy";
    };
  };
}
