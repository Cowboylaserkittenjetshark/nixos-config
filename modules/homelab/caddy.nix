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
        trusted_proxies cloudflare
        trusted_proxies static 127.0.0.1
      }
    '';
    extraConfig = ''
      (cloudflare-dns) {
        import ${config.age.secrets.cloudflare-tunnel-api-token.path}
      }
    '';
    virtualHosts = {
      "*.${domain}".extraConfig = ''
        import cloudflare-dns
        redir https://${domain}{uri} permanent
      '';
      "vw.${domain}".extraConfig = ''
        # TODO Block external access to admin GUI
        import cloudflare-dns
        reverse_proxy 127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}
      '';
      "${domain}".extraConfig = ''
        import cloudflare-dns
        respond "Hello, world :)"
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];
  age.secrets.cloudflare-tunnel-api-token = {
    file = ../../secrets/cloudflare-tunnel-api-token.age;
    mode = "400";
    owner = "caddy";
    group = "caddy";
  };
}
