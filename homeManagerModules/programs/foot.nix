{ osConfig, ... }: {
  programs.foot.enable = osConfig.desktopEnvironment.enable;
}
