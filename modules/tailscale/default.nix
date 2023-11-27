{...}: {
  imports = [./common.nix];

  services.tailscale.useRoutingFeatures = "both";
}
