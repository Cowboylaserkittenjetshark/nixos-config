_: {
  imports = [
    ./hypridle.nix
    ./niri.nix
    ./noctalia.nix
  ];

  services.polkit-gnome.enable = true;
}
