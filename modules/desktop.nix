{...}: {
  imports = [
    ./core.nix
    ./desktopEnvironment
    ./services/printing.nix
    ./authentication
    ./programs/steam.nix
    ./programs/gnupg.nix
    ./programs/chromium.nix
  ];
}
