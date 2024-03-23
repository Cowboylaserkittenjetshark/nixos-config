{pkgs, ...}: {
  imports = [
    # ./containers/caddy.nix
    # ./caddy.nix
    ./containers/mosquitto.nix
    ./containers/homeassistant.nix
    
  ];

  options = {};

  config = {};
}
