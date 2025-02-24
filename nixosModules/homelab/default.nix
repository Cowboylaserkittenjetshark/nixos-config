{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./caddy.nix
    ./cloudflared.nix
    ./vaultwarden.nix
    ./nextcloud.nix
    # ./containers/mosquitto.nix
    # ./containers/homeassistant.nix
    ./backups.nix
    ./mediaserver
    ./adguardhome.nix
    # ./octoprint.nix
  ];

  options.homelab = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the homelab module";
    };
    domain = mkOption {
      type = types.str;
      default = "example.com";
      description = "Base domain";
    };
    vpnAccess = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable exposing private services over a VPN";
      };
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
}
