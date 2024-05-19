{inputs, ...}: {
  imports = [
    ./builders.nix
    ./substituters.nix
  ];

  # Pin registry entry for nixpkgs to the current generation's version
  # Prevents downloading nixpkgs pretty much every time nix shell/run is run
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
}
