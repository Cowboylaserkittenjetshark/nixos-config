{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    users.cblkjs = import ../homeManagerModules;
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
}
