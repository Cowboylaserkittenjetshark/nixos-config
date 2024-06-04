{
  pkgs,
  inputs,
  config,
  ...
}: let
  domain = "cblkjs.com";
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
