{
  flake,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (inputs.nix-on-droid.lib) nixOnDroidConfiguration;
  specialArgs = {inherit inputs;};
in {
  flake = {
    nixosConfigurations = {
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

    nixOnDroidConfigurations = {
      No1TypeP = nixOnDroidConfiguration {
        inherit specialArgs;
        modules = [
          ./No1TypeP
        ];
      };
      default = flake.nixOnDroidConfigurations.No1TypeP;
    };
  };
}
