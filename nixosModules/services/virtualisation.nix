{ lib, pkgs, config, ... }:
{
  environment.systemPackages = lib.optionals config.desktopEnvironment.enable (with pkgs; [
    winboat
    docker-compose
  ]);

  virtualisation.docker.enable = true;
}
