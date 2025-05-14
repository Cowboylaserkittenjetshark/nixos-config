{
  lib,
  config,
  ...
}:
{
  imports = [
    ./fprint.nix
    ./pam_u2f.nix
  ];

  config = lib.mkIf config.systemAttributes.graphical {
    # Allow wayland lockers to unlock the screen
    security.pam.services.hyprlock.text = "auth include login";
  };
}
