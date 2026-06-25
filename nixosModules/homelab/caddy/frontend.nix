{ lib, config, ... }: let
  inherit (config.homelab) frontend backend domain;
in {
  config = lib.mkIf frontend.enable {
    services.caddy.virtualHosts."*.${domain}".extraConfig = "reverse_proxy ${backend.hostname}";
  };
}
