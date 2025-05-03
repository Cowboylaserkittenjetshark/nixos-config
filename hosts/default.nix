{
  config,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem genAttrs;
  inherit (inputs.nix-on-droid.lib) nixOnDroidConfiguration;

  specialArgs = {inherit inputs;};

  mkNixosConfigurations = hosts: genAttrs hosts (host: nixosSystem {
    inherit specialArgs;
    modules = [
      ./${host}

      # Common modules
      ../nixosModules
      inputs.disko.nixosModules.disko
      inputs.lanzaboote.nixosModules.lanzaboote
    ];
  });
in {
  flake = {
    nixosConfigurations = mkNixosConfigurations [
      "lap"
      "tower"
      "No2TypeL"
      "No2TypeT"
    ];

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
