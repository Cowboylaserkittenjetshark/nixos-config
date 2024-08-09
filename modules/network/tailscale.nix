{
  pkgs,
  config,
  ...
}: let
  inherit (config.systemAttributes) roles;
in {
  services.tailscale = {
    enable = true;
    useRoutingFeatures =
      if roles.server
      then
        (
          if (roles.laptop || roles.desktop)
          then "both"
          else "server"
        )
      else "client";
  };

  environment.systemPackages = [pkgs.tailscale];
}
