{
  lib,
  config,
  ...
}:
with lib; {
  services.adguardhome = {
    enable = true;
    mutableSettings = true;
  };
  networking.firewall.interfaces = mkIf config.homelab.vpnAccess.enable {
    ${config.homelab.vpnAccess.interface} = {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53];
    };
  };
}
