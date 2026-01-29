{
  config,
  pkgs,
  ...
}: {
  config.home.packages = [
    pkgs.tofi
  ];
  config.home.file."${config.home.homeDirectory}/.config/tofi/config".text = ''
    hint-font = false
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
