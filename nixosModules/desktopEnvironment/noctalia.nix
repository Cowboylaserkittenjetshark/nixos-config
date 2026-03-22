{ inputs, ... }:
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];

  services.noctalia-shell.enable = false;
}
