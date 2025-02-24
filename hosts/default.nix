{
  config,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (inputs.nix-on-droid.lib) nixOnDroidConfiguration;
  withCommonModules = path: ([path]
    ++ [
      ../nixosModules
      inputs.disko.nixosModules.disko
      inputs.lanzaboote.nixosModules.lanzaboote
    ]);
  specialArgs = {inherit inputs;};
in {
  flake = {
    nixosConfigurations = {
      lap = nixosSystem {
        inherit specialArgs;
        modules = withCommonModules ./lap;
      };
      tower = nixosSystem {
        inherit specialArgs;
        modules = withCommonModules ./tower;
      };
      No2TypeL = nixosSystem {
        inherit specialArgs;
        modules = withCommonModules ./No2TypeL;
      };
      No2TypeT = nixosSystem {
        inherit specialArgs;
        modules = withCommonModules ./No2TypeT;
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
