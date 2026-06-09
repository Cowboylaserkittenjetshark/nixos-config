{ lib, config, ... }: {
  config = lib.mkIf config.desktopEnvironment.enable {
    programs.yubikey-touch-detector.enable = true;
    security.pam = {
      u2f.settings.cue = true;
      services = {
        login.u2fAuth = true;
        swaylock.u2fAuth = true;
        sddm.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
  };
}
