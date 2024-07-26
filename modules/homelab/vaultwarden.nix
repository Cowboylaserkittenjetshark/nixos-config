{config, ...}: {
  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden-env.path;
    config = {
      ROCKET_PORT = 8222;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_LOG = "critical";
      DATA_FOLDER = "/var/lib/bitwarden_rs"; # Module requires this value. Hardcoded in several places
    };
  };

  services.caddy.virtualHosts."vw.${config.homelab.domain}".extraConfig = ''
    # Adapted from https://github.com/dani-garcia/vaultwarden/wiki/Proxy-examples

    header / {
    	# Disallow the site to be rendered within a frame (clickjacking protection)
    	X-Frame-Options "SAMEORIGIN"
    	# Prevent search engines from indexing
    	X-Robots-Tag "noindex, nofollow"
    	# Disallow sniffing of X-Content-Type-Options
    	X-Content-Type-Options "nosniff"
    	# Server name removing
    	-Server
    	# Remove X-Powered-By though this shouldn't be an issue, better opsec to remove
    	-X-Powered-By
    	# Remove Last-Modified because etag is the same and is as effective
    	-Last-Modified
    }

    # Block access to the admin GUI
    redir /admin* /

    reverse_proxy 127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT} {
      header_up X-Real-IP {remote_host}
    }
  '';

  age.secrets.vaultwarden-env = {
    file = ../../secrets/vaultwarden-env.age;
    mode = "400";
    owner = "vaultwarden";
    group = "vaultwarden";
  };
}
