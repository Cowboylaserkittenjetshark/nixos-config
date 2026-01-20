{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    winboat
    podman-compose
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
