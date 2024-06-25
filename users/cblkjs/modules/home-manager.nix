{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    users.cblkjs = import ../home.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
}
