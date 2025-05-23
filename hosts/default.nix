{
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs.lib) nixosSystem genAttrs;

  mkNixosConfigurations =
    hosts:
    genAttrs hosts (
      host:
      nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./${host}

          # Common modules
          ../nixosModules
          inputs.disko.nixosModules.disko
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nix-index-database.nixosModules.nix-index
        ];
      }
    );
in
{
  flake.nixosConfigurations = mkNixosConfigurations [
    "lap"
    "tower"
    "No2TypeL"
    "No2TypeT"
    "No3TypeL"
  ];
}
