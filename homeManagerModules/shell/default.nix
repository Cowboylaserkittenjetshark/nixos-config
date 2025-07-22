{inputs, ...}: {
  imports = [
    ./direnv.nix
    ./zoxide.nix
    ./fish.nix
    ./starship.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.nix-index.enable = true;
}
