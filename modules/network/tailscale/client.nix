{...}: {
  imports = [./common.nix];

  services.tailscale.useRoutingFeatures = "client";
}
