{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.systemAttributes.roles.desktop {
    programs.hyprland.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
