{pkgs, ...}: let
  caddy_config = pkgs.writeText "Caddyfile" ''
    cblkjs.com

    respond "Hello, world!
  '';
in {
  virtualisation.oci-containers.containers.caddy = {
    image = "docker.io/library/caddy:latest";
    ports = [
      "80:80"
      "443:443"
      "443:443/udp"
    ];
    volumes = [
      # "${caddy_config}:/etc/caddy/Caddyfile"
      # "caddy_data:/data"
      # "caddy_config:/config"
    ];
    extraOptions = [
      "--network=podman,proxied" # Can add multiple networks
    ];
  };
}
