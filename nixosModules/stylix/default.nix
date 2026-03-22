{ inputs, pkgs, lib, ... }: let
  wallpaper = ./forest_kingdom_desktop.jpg;
  theme = "everforest-dark-hard";
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
    image = pkgs.runCommand "wallpaper.jpg" {} ''
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
        package = pkgs.sarasa-gothic;
        name = "Sarasa Gothic J";
      };

      sansSerif = {
        package = pkgs.sarasa-gothic;
        name = "Sarasa UI J";
      };

      monospace = {
        package = pkgs.sarasa-gothic;
        name = "Sarasa Term J";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

  };
}
