{
  config,
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
          ../modules
        ];
      };
      tower = nixosSystem {
        inherit specialArgs;
        modules = [
          ./tower
          ../users/cblkjs
          ../modules
        ];
      };
      No2TypeL = nixosSystem {
        inherit specialArgs;
        modules = [
          ./No2TypeL
          ../users/cblkjs
          ../modules
        ];
      };
      No2TypeT = nixosSystem {
        inherit specialArgs;
        modules = [
          ./No2TypeT
          ../users/cblkjs
          ../modules
        ];
      };
    };

    nixOnDroidConfigurations = {
      No1TypeP = nixOnDroidConfiguration {
        extraSpecialArgs = specialArgs;
        modules = [
          ./No1TypeP
        ];
      };
      default = config.flake.nixOnDroidConfigurations.No1TypeP;
    };
  };
}
