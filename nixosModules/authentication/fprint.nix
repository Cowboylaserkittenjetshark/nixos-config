{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (builtins.elem "fingerprint" config.systemAttributes.capabilities) {
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
