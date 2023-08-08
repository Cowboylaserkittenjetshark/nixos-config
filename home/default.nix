{ config, pkgs, home-manager, ... }:
{
  modules = [
    home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.cblkjs = import ./users/cblkjs;
  # Optionally, use home-manager.extraSpecialArgs to pass
  # arguments to home.nix
}
