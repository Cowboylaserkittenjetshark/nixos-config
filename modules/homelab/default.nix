{pkgs, ...}: {
  imports = [
    # ./containers/caddy.nix
    # ./caddy.nix
    # ./containers/mosquitto.nix
    # ./containers/homeassistant.nix
    ./microvm
  ];

  options = {};

  config = {};
}
