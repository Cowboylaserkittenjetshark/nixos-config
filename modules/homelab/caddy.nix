{
  pkgs,
  inputs,
  config,
  ...
}: {
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
    package = inputs.custom-caddy.packages.${pkgs.system}.default;
    virtualHosts."cblkjs.com".extraConfig = ''
      respond "Hello, world :)"
      import ${config.age.secrets.cloudflare-tunnel-api-token.path}
    '';
    extraConfig = ''
    '';
  };
  networking.firewall.allowedTCPPorts = [80 443];
  age.secrets.cloudflare-tunnel-api-token = {
    file = ../../secrets/cloudflare-tunnel-api-token.age;
    mode = "400";
    owner = "caddy";
    group = "caddy";
  };
  # containers.caddy = {
  #   autoStart = true;
  #   privateNetwork = true;
  # };
}
