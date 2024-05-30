{...}: {
  imports = [
    ./core.nix
    ./programs/gnupg.nix
    ./network/ssh/server.nix
  ];
}
