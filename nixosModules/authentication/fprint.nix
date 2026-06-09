{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.hardware.facter.detected.fingerprint.enable {
    security.pam.services = {
      login.fprintAuth = true;
      swaylock.fprintAuth = true;
      sddm.fprintAuth = true;
      sudo.fprintAuth = true;
    };
  };
}
