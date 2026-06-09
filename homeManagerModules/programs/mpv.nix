{ osConfig, ... }: {
  programs.mpv.enable = osConfig.desktopEnvironment.enable;
}
