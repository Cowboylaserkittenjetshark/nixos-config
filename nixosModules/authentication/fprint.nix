{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.systemAttributes.fingerprint {
    services.fprintd.enable = true;
    security.pam = {
      services = {
        login.fprintAuth = true;
        swaylock.fprintAuth = true;
        sddm.fprintAuth = true;
        sudo.fprintAuth = true;
      };
    };
  };
}
