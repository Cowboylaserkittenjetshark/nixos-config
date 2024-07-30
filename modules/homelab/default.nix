{
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./caddy.nix
    ./cloudflared.nix
    ./vaultwarden.nix
    ./nextcloud.nix
    # ./containers/mosquitto.nix
    # ./containers/homeassistant.nix
    ./backups.nix
    ./mediaserver
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
      description = mdDoc ''
        Base domain
      '';
    };
    vpnInterface = mkOption {
      type = types.str;
      default = null;
      description = mdDoc ''
        Name of the vpn interface to expose private services to
      '';
    };
  };
}
