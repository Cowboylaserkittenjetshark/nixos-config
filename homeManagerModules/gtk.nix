{
  pkgs,
  ...
}: {
  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Green-Dark-Compact-Catppuccin";
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = ["green"];
        colorVariants = ["dark"];
        sizeVariants = ["compact"];
        tweaks = ["catppuccin" "black" "rimless"];
      };
    };
  };
}
