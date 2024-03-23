{pkgs, ...}: {
  virtualisation.oci-containers.containers.homeassistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    ports = [
      "8123:8123"
    ];
    volumes = [
      "homeassistant-config:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
    extraOptions = [
      "--network=proxied,mqtt" # Can add multiple networks
    ];
  };
}
