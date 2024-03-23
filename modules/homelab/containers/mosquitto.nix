{pkgs, ...}: let
  mosquitto_config = pkgs.writeText "mosquitto.conf" ''
    persistence true
    persistence_location /mosquitto/data/
    log_dest file /mosquitto/log/mosquitto.log
    allow_anonymous true
    listener 1883
  '';
in {
  virtualisation.oci-containers.containers.mosquitto = {
    image = "docker.io/library/eclipse-mosquitto:latest";
    ports = [
      "1883:1883"
      "9001:9001"
    ];
    volumes = [
      "${mosquitto_config}:/mosquitto/config/mosquitto.conf"
      "mosquitto-data:/mosquitto/data/"
      "mosquitto-log:/mosquitto/log/"
    ];
    extraOptions = [
      "--network=mqtt" # Can add multiple networks
    ];
  };
}
