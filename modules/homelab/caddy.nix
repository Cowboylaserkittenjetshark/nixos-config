{pkgs, ...}: {
  # virtualisation.oci-containers.containers.caddy = {
  #   image = "docker.io/library/caddy:latest";
  #   ports = [
  #     "80:80"
  #     "443:443"
  #     "443:443/udp"
  #   ];
  #   volumes = [
  #     "${caddy_config}:/etc/caddy/Caddyfile"
  #     "caddy_data:/data"
  #     "caddy_config:/config"
  #   ];
  #   extraOptions = [
  #     "--network=podman,proxied" # Can add multiple networks
  #   ];
  # };
  services.caddy = {
    enable = true;
    virtualHosts.":80".extraConfig = ''
      respond "Hello, world :)"
    '';
  };
  networking.firewall.allowedTCPPorts = [80 443];
}
