{
  config,
  lib,
  ...
}:
let
  inherit (config.homelab) domain enable;
  subdomain = "oidc";
  port = "1411";
in
{
  config = lib.mkIf enable {
    services.caddy.virtualHosts."${subdomain}.${domain}".extraConfig = ''
      reverse_proxy 127.0.0.1:${port}
    '';

  services.pocket-id = {
    enable = true;
    credentials = {
      ENCRYPTION_KEY = config.age.secrets.pocket-id-encryption-key.path;
      MAXMIND_LICENSE_KEY = config.age.secrets.maxmind-license-key.path;
    };
    settings = {
      APP_URL = "https://${subdomain}.${domain}";
      TRUST_PROXY = true;
      ANALYTICS_DISABLED = true;
      PORT = port;
    };
  };

    age.secrets = {
      pocket-id-encryption-key = {
        file = ../../secrets/pocket-id-encryption-key.age;
        mode = "400";
      };
      maxmind-license-key = {
        file = ../../secrets/maxmind-license-key.age;
        mode = "400";
      };
    };
  };
}
