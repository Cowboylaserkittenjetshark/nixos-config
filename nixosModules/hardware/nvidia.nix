{lib, ...}: {
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };

  # Loads the driver for Xorg AND Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];
}
