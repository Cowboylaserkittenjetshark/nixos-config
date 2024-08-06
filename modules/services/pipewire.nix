{lib, config, ...}: {
  config = lib.mkIf (builtins.elem "audio" config.systemAttributes.capabilities) {
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
