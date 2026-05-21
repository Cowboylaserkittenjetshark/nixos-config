{ osConfig, ... }: {
  services = {
    opensnitch-ui.enable = osConfig.services.opensnitch.enable;
  };
}
