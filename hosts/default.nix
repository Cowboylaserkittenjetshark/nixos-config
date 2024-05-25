{inputs, ...}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    specialArgs = {inherit inputs;};
  in {
    lap = nixosSystem {
      inherit specialArgs;
      modules = [
        ./lap
        ../users/cblkjs
      ];
    };
    tower = nixosSystem {
      inherit specialArgs;
      modules = [
        ./tower
        ../users/cblkjs
      ];
    };
    No2TypeL = nixosSystem {
      inherit specialArgs;
      modules = [
        ./No2TypeL
        ../users/cblkjs
      ];
    };
  };
}
