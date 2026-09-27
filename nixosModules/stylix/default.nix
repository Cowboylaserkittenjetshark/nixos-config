{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  wallpaper = ./forest_kingdom_desktop.jpg;
  theme = "everforest-dark-hard";
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
    image = pkgs.runCommand "wallpaper.jpg" { } ''
      ${lib.getExe pkgs.lutgen} apply -p ${theme} -P "${wallpaper}" --output $out
    '';
    opacity = {
      applications = 0.9;
      desktop = 0.9;
      popups = 0.6;
      terminal = 0.9;
    };
    fonts = {
      serif = {
        package = pkgs.atkinson-hyperlegible-next;
        name = "Atkinson Hyperlegible Next";
      };

      sansSerif = {
        package = pkgs.atkinson-hyperlegible-next;
        name = "Atkinson Hyperlegible Next";
      };

      monospace = {
        package = pkgs.atkinson-hyperlegible-mono;
        name = "Atkinson Hyperlegible Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    cursor = {
      package = pkgs.posy-cursors;
      name = "Posy_Cursor_Black";
      size = 32;
    };
  };
}
