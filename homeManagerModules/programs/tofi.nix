{
  config,
  pkgs,
  ...
}:
let
  font = "${pkgs.meslo-lgs-nf}/share/fonts/truetype/MesloLGS NF Bold.ttf";
in
{
  config.home.packages = [
    pkgs.tofi
  ];
  config.home.file."${config.home.homeDirectory}/.config/tofi/config".text = ''
    font = "${font}"
    hint-font = false
    font-size = 24
    text-color = #cdd6f4
    selection-color = #a6e3a1
    background-color = #1e1e2ef0
    anchor = top
    width = 100%
    height = 100%
    padding-top = 5%
    padding-bottom = 35%
    padding-left = 35%
    padding-right = 35%
    outline-width = 0
    border-width = 0
    num-results = 5
    result-spacing = 25
    hide-cursor = true
    prompt-text = ""
    hide-input = true
    hidden-character = ""
    history = true
    matching-algorithm = fuzzy
    multi-instance = false
  '';
}
