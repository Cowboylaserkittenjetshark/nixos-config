{lib, ...}: {
  programs.cava = {
    enable = true;
    settings.color.background = lib.mkForce "default";
  };
}
