_: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      # Needs https://github.com/helix-editor/helix/pull/11164
      keys.normal."A-t" = ":run-shell-command sioyek %{filename}";
    };
    languages = {
      language = [
        {
          name = "typst";
          auto-format = true;
        }
      ];
      language-server.tinymist.config = {
        exportPdf = "onType";
        outputPath = "$root/target/$dir/$name";
        formatterMode = "typstyle";
      };
    };
  };
}
