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
  };

  config = mkIf cfg.enable {
    # TODO
  };
}
