{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.systemAttributes.roles.server {
    services.openssh = {
      enable = true;
      # require public key authentication for better security
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
      settings.PermitRootLogin = "no";
    };
  };
}
