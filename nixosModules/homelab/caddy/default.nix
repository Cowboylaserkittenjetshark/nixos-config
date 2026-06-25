{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.homelab) frontend backend;
  inherit (lib) mkIf;
  plugins = {
    plugins = [
      "github.com/caddy-dns/cloudflare@v0.2.1"
    ];
    hash = "sha256-I0FjQOfFaGlOEJlQECmYNBKjIY4CIg5aCCQ/ORmnrSU=";
  };
in
{
  imports = [
    ./frontend.nix
    ./backend.nix
  ];
  config = mkIf (backend.enable || frontend.enable) {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins plugins;
      globalConfig = ''
        # Contains `acme_dns cloudflare <token>`
        import ${config.age.secrets.caddy-cloudflare-dns.path}
      '';
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    age.secrets.caddy-cloudflare-dns = {
      file = ../../../secrets/caddy-cloudflare-dns.age;
      mode = "400";
      owner = "caddy";
      group = "caddy";
    };
  };
}
