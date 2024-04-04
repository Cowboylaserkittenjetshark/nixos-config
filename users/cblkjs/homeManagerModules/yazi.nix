{inputs, ...}: {
  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        show_hidden = true;
        show_symlink = true;
        scrolloff = 200; # Force centering the cursor
      };
    };
  };

  home.shellAliases = {y = "yazi";};

  xdg.configFile = {
    "yazi/theme.toml".source = "${inputs.catppuccin-yazi}/themes/mocha.toml";
    "yazi/Catppuccin-mocha.tmTheme".source = "${inputs.catppuccin-bat}/themes/Catppuccin Mocha.tmTheme";
  };
}
