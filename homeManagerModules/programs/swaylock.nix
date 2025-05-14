{ pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
      screenshots = true;
      effect-blur = "10x3";
      fade-in = 0.5;
      grace = 5;
      clock = true;
      font = "MesloLGS NF";
      bs-hl-color = "eba0ac";
      inside-color = "1e1e2e";
      inside-clear-color = "1e1e2e";
      inside-ver-color = "1e1e2e";
      inside-wrong-color = "1e1e2e";
      key-hl-color = "585b70";
      ring-color = "11111b";
      ring-clear-color = "9399b2";
      ring-caps-lock-color = "eba0ac";
      ring-ver-color = "9399b2";
      ring-wrong-color = "eba0ac";
      line-uses-inside = true;
      separator-color = "00000000";
      text-color = "cdd6f4";
      text-clear-color = "cdd6f4";
      text-caps-lock-color = "cdd6f4";
      text-ver-color = "cdd6f4";
      text-wrong-color = "cdd6f4";
    };
  };
}
