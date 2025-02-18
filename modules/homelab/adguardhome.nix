{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkAfter;
  inherit (config.homelab) vpnAccess domain;
  providers = {
    Quad9 = {
      DoH = ["https://dns.quad9.net/dns-query"];
      IPv4 = [
        "9.9.9.9"
        "149.112.112.112"
      ];
    };
    ControlD = {
      DoH = ["https://freedns.controld.com/p0"];
      IPv4 = [
        "76.76.2.0"
        "76.76.10.0"
      ];
    };
    Cloudflare = rec {
      DoH = ["https://dns.cloudflare.com/dns-query"];
      IPv4 = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      all = DoH ++ IPv4;
    };
  };
in {
  config = mkIf config.homelab.enable {
    services = {
      adguardhome = {
        enable = true;
        mutableSettings = false;
        settings = {
          users = [
            {
              name = "admin";
              password = "@adguard-home-webui-password@";
            }
          ];
          http.address = "127.0.0.1:3000";
          language = "en";
          dns = with providers; {
            bind_hosts = ["127.0.0.1"] ++ (if vpnAccess.enable then [vpnAccess.address] else []);
            port = 53;
            bootstrap_dns = Quad9.IPv4 ++ ControlD.IPv4;
            upstream_dns = Quad9.DoH ++ ControlD.DoH;
            fallback_dns = Quad9.IPv4 ++ ControlD.IPv4 ++ Cloudflare.all;
          };
          filtering.rewrites = mkIf vpnAccess.enable [
            {
              domain = "*.${domain}";
              answer = "${vpnAccess.address}";
            }
            {
              domain = "${domain}";
              answer = "${vpnAccess.address}";
            }
          ];
        };
      };
      resolved.fallbackDns = [];
    };
    networking = mkIf vpnAccess.enable {
      firewall.interfaces.${vpnAccess.interface}.allowedUDPPorts = [53];
    };

    services.caddy.virtualHosts."dns.${domain}".extraConfig = ''
      import localOnly
      reverse_proxy 127.0.0.1:3000
    '';

    age.secrets.adguard-home-webui-password = {
      file = ../../secrets/adguard-home-webui-password.age;
      mode = "400";
    };

    systemd.services.adguardhome = {
      serviceConfig.ExecStartPre = mkAfter [
        "+${(pkgs.writeShellScript "install-adguard-home-webui-password" ''
          secret=$(<${config.age.secrets.adguard-home-webui-password.path})
          configFile=/var/lib/AdGuardHome/AdGuardHome.yaml
          ${pkgs.gnused}/bin/sed -i "s#@adguard-home-webui-password@#$secret#" "$configFile"
        '')}"
      ];
    };
  };
}
