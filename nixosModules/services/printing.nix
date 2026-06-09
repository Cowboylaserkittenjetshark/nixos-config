{ lib, pkgs, config, ... }:
{
  config = lib.mkIf config.desktopEnvironment.enable {
    services = {
      printing.enable = true; # enables printing support via the CUPS daemon
      avahi = {
        enable = true; # runs the Avahi daemon
        nssmdns4 = true; # enables the mDNS NSS plug-in
        openFirewall = true; # opens the firewall for UDP port 5353
      };
    };
    hardware.sane = {
      enable = true;
      extraBackends = [
        (pkgs.epkowa.override {
          plugins = {
            inherit (pkgs.epkowa.plugins) ds30;
          };
        })
      ];
    };
  };
}
