{...}: {
  services.fprintd.enable = true;
  security.pam = {
    services = {
      login.fprintAuth = true;
      swaylock.fprintAuth = true;
      sddm.fprintAuth = true;
      sudo.fprintAuth = true;
    };
  };
}
