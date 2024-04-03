{ inputs, ... }: let
  # Def stuff
in
{
  imports = [
    inputs.microvm.nixosModules.host
    ./hostNetwork.nix
    ./caddy.nix
  ];
}
