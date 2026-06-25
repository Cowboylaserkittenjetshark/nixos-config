{ lib, config, ... }:
let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.homelab;
in
{
  imports = [
    ./caddy
    ./vaultwarden.nix
    ./nextcloud.nix
    ./backups.nix
    ./mediaserver
    ./adguardhome.nix
    ./octoprint.nix
    ./rooted-graphene.nix
    ./fmd-server.nix
    ./pocket-id.nix
  ];

  options.homelab = {
    backend = {
      enable = mkEnableOption "the backend services";
      hostname = {
        type = types.str;
        default = "tower";
        description = "Hostname of the backend server (used for tailscale)";
      };
      address = mkOption {
        type = types.str;
        default = "100.109.116.3";
        description = "IP address of the backend server (used for tailscale)";
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
    frontend = {
      enable = mkEnableOption "the frontend services";
      hostname = {
        type = types.str;
        default = "No1TypeC";
        description = "Hostname of the frontend server (used for tailscale)";
      };
      address = mkOption {
        type = types.str;
        default = "100.71.159.53";
        description = "IP address of the frontend server (used for tailscale)";
      };
    };
    domain = mkOption {
      type = types.str;
      default = "cblkjs.com";
      description = "Base domain";
    };
  };

  config.assertions = [
    {
      assertion = !(cfg.backend.enable && cfg.frontend.enable);
      message = "The frontend and backend componenets of the homelab module may not be enabled on the same server";
    }
  ];
}
