{
  pkgs,
  ...
}: {
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batman batgrep batwatch];
  };
  home.shellAliases = {cat = "bat";};
}
