{inputs, ...}: {
  programs.yazi = {
    enable = true;
  };

  xdg.configFile = {
    "yazi/theme.toml".source = "${inputs.catppuccin-yazi}/themes/mocha.toml";
    "yazi/Catppuccin-mocha.tmTheme".source = "${inputs.catppuccin-bat}/themes/Catppuccin Mocha.tmTheme";
  };
}
