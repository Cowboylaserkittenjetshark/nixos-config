{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./hyprlock.nix
  ];

  options = {};

  config = {};
}
