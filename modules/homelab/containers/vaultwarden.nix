{
  pkgs,
  config,
  ...
}: let
in {
  virtualisation.oci-containers.containers.vaultwarden = {
    image = "ghcr.io/dani-garcia/vaultwarden:latest-alpine";
    ports = [
      "127.0.0.1:8080:80"
    ];
    volumes = [
      "vaultwarden-data:/data"
    ];
    environmentFiles = [config.age.secrets.vaultwarden-env.path];
  };
  age.secrets.vaultwarden-env = {
    file = ../../../secrets/vaultwarden-env.age;
    # mode = "400";
    # owner = "caddy";
    # group = "caddy";
  };
}
