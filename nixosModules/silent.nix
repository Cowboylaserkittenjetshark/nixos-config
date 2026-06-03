{ lib, ... }: {
  options.boot.silent.enable = lib.mkEnableOption "silencing boot mesages";
  config.boot = lib.mkIf config.options.boot.silent.enable {
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
  };
}
