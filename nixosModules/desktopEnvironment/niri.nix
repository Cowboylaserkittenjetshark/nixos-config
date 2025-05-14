{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.systemAttributes.roles.laptop {
    programs.niri.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
