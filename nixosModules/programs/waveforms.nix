{ lib, pkgs, config, inputs, ... }:
{
  config = lib.mkIf config.desktopEnvironment.enable {
    nixpkgs.overlays = [ inputs.waveforms.overlay ];
    services.udev.packages = [ pkgs.adept2-runtime ];
    environment.systemPackages = [ pkgs.waveforms ];
    users.groups.plugdev = { };
  };
}
