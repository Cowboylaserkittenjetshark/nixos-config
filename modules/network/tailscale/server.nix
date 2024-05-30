{...}: {
  imports = [./common.nix];

  services.tailscale.useRoutingFeatures = "server";
}
