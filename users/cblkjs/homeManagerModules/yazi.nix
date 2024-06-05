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
}
