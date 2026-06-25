{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.homelab) domain backend;
  inherit (backend) enable;
  subdomain = "oidc";
  port = "1411";
  email = "no-reply@cblkjs.com";
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
      SMTP_PASSWORD = config.age.secrets.smtp-password.path;
    };
    settings = {
      APP_URL = "https://${subdomain}.${domain}";
      TRUST_PROXY = true;
      ANALYTICS_DISABLED = true;
    };
    environmentFile = pkgs.writeText "pocket-id.env" ''
      UI_CONFIG_DISABLED=true
      SMTP_HOST=smtp.migadu.com
      SMTP_PORT=465
      SMTP_FROM=${email}
      SMTP_USER=${email}
      SMTP_TLS=tls
      EMAIL_LOGIN_NOTIFICATION_ENABLED=true
      EMAIL_ONE_TIME_ACCESS_AS_ADMIN_ENABLED=true
      EMAIL_API_KEY_EXPIRATION_ENABLED=true
      EMAIL_VERIFICATION_ENABLED=true
    '';
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
      smtp-password = {
        file = ../../secrets/smtp-password.age;
        mode = "400";
      };
    };
  };
}
