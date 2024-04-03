{
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
    };
    extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
    themes = let
      inherit (lib) mapAttrs' genAttrs nameValuePair;
    in
      mapAttrs'
      (name: value: nameValuePair "Catppuccin ${name}" value)
      (
        genAttrs
        ["Mocha" "Macchiato" "Latte" "Frappe"]
        (variant: {
          src = inputs.catppuccin-bat;
          file = "themes/Catppuccin ${variant}.tmTheme";
        })
      );
  };
}
