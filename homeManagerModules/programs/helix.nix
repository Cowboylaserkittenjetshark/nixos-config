{inputs, pkgs, ...}: let
  sioyek-launcher = pkgs.writeScript "sioyek-launcher" ''
    #! /usr/bin/env zsh
    PDF_PATH=''${1:h}/target/''${1:t:s/typ/pdf}
    if [[ $PDF_PATH:e != "pdf" ]]; then
      exit 1
    else
      sioyek $PDF_PATH
    fi
  '';
in {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    defaultEditor = true;
    settings = {
      keys.normal."A-t" = ":sh ${sioyek-launcher} %{buffer_name}";
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
