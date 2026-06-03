{ lib, config, ... }: {
  options.boot.silent = lib.mkEnableOption "silencing boot mesages";
  config.boot = lib.mkIf config.boot.silent {
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];
  };
}
