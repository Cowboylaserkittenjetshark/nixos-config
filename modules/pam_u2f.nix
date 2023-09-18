{...}: {
  security.pam = {
    u2f.cue = true;
    services = {
      login.u2fAuth = true;
      swaylock.u2fAuth = true;
      sddm.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
}
