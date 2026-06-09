{ osConfig, ... }: {
  imports = [
    ./niri.nix
    ./noctalia.nix
  ];

  services.polkit-gnome.enable = osConfig.desktopEnvironment.enable;
}
