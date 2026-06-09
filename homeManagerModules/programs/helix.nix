{
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
    defaultEditor = true;
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
