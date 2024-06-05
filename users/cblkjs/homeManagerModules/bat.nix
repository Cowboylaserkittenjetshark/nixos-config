{
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
  };
  home.shellAliases = {cat = "bat";};
}
