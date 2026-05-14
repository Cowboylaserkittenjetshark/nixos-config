{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.systemAttributes.graphical {
    programs.niri.enable = true;
    environment = {
      systemPackages = [ pkgs.xwayland-satellite ];
      sessionVariables.NIXOS_OZONE_WL = "1";
    };
  };
}
