{
  pkgs,
  inputs,
  ...
}: {
  imports = [./common.nix];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
