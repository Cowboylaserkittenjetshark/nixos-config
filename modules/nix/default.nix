{inputs, ...}: {
  imports = [
    ./builders.nix
    ./substituters.nix
    ./agenix.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Pin registry entry for nixpkgs to the current generation's version
  # Prevents downloading nixpkgs pretty much every time nix shell/run is run
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Optimize storage
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };
}
