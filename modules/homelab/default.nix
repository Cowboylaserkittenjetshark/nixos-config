{pkgs, ...}: {
  imports = [
    ./caddy.nix
    ./containers/vaultwarden.nix
    ./nextcloud.nix
    # ./containers/mosquitto.nix
    # ./containers/homeassistant.nix
  ];

  options = {};

  config = {};
}
