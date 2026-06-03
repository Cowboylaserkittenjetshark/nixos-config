{ lib, config, ... }: {
  # Physical access is required for U2F security keys
  security.pam = lib.mkIf config.systemAttributes.physicalAccess {
    u2f.settings.cue = true;
    services = {
      login.u2fAuth = true;
      swaylock.u2fAuth = true;
      sddm.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
}
