{inputs, ...}: {
  imports = [
    ./direnv.nix
    ./zoxide.nix
    ./fish.nix
    ./starship.nix
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.nix-index.enable = true;
}
