{lib, config, ...}: {
  config = lib.mkIf (builtins.elem "audio" config.systemAttributes.capabilities) {
    services.pipewire = {
      enable = true;
      wireplumber.extraConfig."10-disable-camera" = {
        "wireplumber.profiles" = {
          main."monitor.libcamera" = "disabled";
        };
      };
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
