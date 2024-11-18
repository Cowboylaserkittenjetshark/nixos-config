{
  lib,
  pkgs,
  config,
  ...
}: {
  config = lib.mkIf config.systemAttributes.graphical {
    hardware.amdgpu.opencl.enable = true;
    environment.systemPackages = [pkgs.davinci-resolve];
  };
}
