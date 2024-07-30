{
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (config.homelab) domain;
in {
  services.caddy = {
    enable = true;
    package = inputs.custom-caddy.packages.${pkgs.system}.default;
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
        redir https://${domain}{uri} permanent
      '';
      "${domain}".extraConfig = ''
        respond "Hello, world :)"
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
}
