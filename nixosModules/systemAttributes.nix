{
  config,
  lib,
  ...
}:
let
  cfg = config.systemAttributes;

  inherit (lib) types mkOption listToAttrs;

  mkRole =
    role:
    (mkOption {
      type = types.bool;
      default = false;
      description = "Whether or not the system is a ${role}";
    });

  mkRoleOptions =
    roles:
    (listToAttrs (
      map (role: {
        name = "${role}";
        value = mkRole role;
      }) roles
    ));

  mkBoolOption =
    val:
    (mkOption {
      type = types.bool;
      default = val;
    });
in
{
  options.systemAttributes = {
    roles = mkRoleOptions [
      "desktop"
      "laptop"
      "phone"
      "server"
    ];

    physicalAccess = mkBoolOption false;
    fingerprint = mkBoolOption false;
    bluetooth = mkBoolOption false;
    audio = mkBoolOption false;
    lan = {
      wired = mkBoolOption false;
      wireless = mkBoolOption false;
    };
    headless = mkBoolOption true;
    graphical = mkBoolOption false;
  };
}
