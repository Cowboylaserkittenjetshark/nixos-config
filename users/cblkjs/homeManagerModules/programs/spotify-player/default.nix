{...}: {
  imports = [
    ./theme.nix
  ];

  programs.spotify-player = {
    enable = true;
    settings.theme = "Catppuccin-mocha";
  };
}
