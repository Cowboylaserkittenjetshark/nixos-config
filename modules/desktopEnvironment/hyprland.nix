{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.systemAttributes.graphical {
    programs.hyprland.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
