{pkgs, ...}: {
  imports = [
    ./caddy.nix
    ./vaultwarden.nix
    ./nextcloud.nix
    # ./containers/mosquitto.nix
    # ./containers/homeassistant.nix
    ./backups.nix
  ];

  options = {};

  config = {};
}
