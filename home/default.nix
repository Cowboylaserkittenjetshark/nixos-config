{ config, pkgs, ... }: 
{
  imports = [
    ./hyprland
  ];

  home = {
    username = "cblkjs";
    homeDirectory = "/home/cblkjs";
  }
}
