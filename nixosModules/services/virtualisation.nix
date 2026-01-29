{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    winboat
    docker-compose
  ];

  virtualisation.docker.enable = true;
}
