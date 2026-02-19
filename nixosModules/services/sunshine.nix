{lib, config, ...}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.services.sunshine;
  generatePorts = port: offsets: map (offset: port + offset) offsets;
in {
  options.services.sunshine = {
    vpnAccess = {
      enable = mkEnableOption "exposing ports over the configured vpn";
      interface = mkOption {
        type = types.str;
        default = null;
        description = "Name of the vpn interface";
      };
      address = mkOption {
        type = types.str;
        default = null;
        description = "IP address (or domain like one from Tailscale MagicDNS) of the server on the vpn";
      };
    };
  };

  config = {
    services.sunshine.autoStart = false;
    networking.firewall.interfaces.${config.services.sunshine.vpnAccess.interface} = mkIf config.services.sunshine.vpnAccess.enable {
      allowedTCPPorts = generatePorts cfg.settings.port [
        (-5)
        0
        1
        21
      ];
      allowedUDPPorts = generatePorts cfg.settings.port [
        9
        10
        11
        13
        21
      ];
    };
  };
}
