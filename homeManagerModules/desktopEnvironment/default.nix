_: {
  imports = [
    ./niri.nix
    ./noctalia.nix
  ];

  services.polkit-gnome.enable = true;
}
