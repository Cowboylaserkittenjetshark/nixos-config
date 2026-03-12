_: {
  imports = [
    ./desktopAssets.nix
    ./greetd.nix
    ./hyprland.nix
    ./niri.nix
    ./noctalia.nix
  ];

  security.polkit.enable = true;
}
