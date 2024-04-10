{inputs, pkgs, ...}: {
  imports = [
    # ./containers/caddy.nix
    # ./caddy.nix
    # ./containers/mosquitto.nix
    # ./containers/homeassistant.nix
<<<<<<< Updated upstream
    ./microvm
=======
    ./microvms
>>>>>>> Stashed changes
  ];

  options = {};

  config = {};
}
