{pkgs, ...}: {
  programs.eww = {
    enable = true;
    configDir = ./config;
    package = pkgs.eww;
  };
}
