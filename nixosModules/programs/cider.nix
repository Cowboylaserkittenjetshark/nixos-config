{ lib, pkgs, config, ... }:
{
  environment.systemPackages = lib.optional config.desktopEnvironment.enable pkgs.cider-2;
}
