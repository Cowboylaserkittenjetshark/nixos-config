{...}: {
  imports = [
    ./fprint.nix
    ./pam_u2f.nix
  ];

  # Allow wayland lockers to unlock the screen
  security.pam.services.hyprlock.text = "auth include login";
}
