{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
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
        http.address = "0.0.0.0:3000";
        language = "en";
        dns = {
          bind_hosts = ["0.0.0.0"];
          port = 53;
          bootstrap_dns = [
            "9.9.9.10"
            "149.112.112.10"
            "2620:fe::10"
            "2620:fe::fe:10"
          ];
        };
        filtering.rewrites = mkIf config.homelab.vpnAccess.enable [
          {
            domain = "*.${config.homelab.domain}";
            answer = "${config.homelab.vpnAccess.address}";
          }
          {
            domain = "${config.homelab.domain}";
            answer = "${config.homelab.vpnAccess.address}";
          }
        ];
      };
    };
    resolved.enable = mkForce false;
  };
  networking.firewall.interfaces = mkIf config.homelab.vpnAccess.enable {
    ${config.homelab.vpnAccess.interface} = {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53];
    };
  };

  services.caddy.virtualHosts."dns.${config.homelab.domain}".extraConfig = ''
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
}
