{
  copnfig,
  lib,
  ...
}:
with lib; let
  mkRole = role:
    mkOption {
      type = types.bool;
      default = false;
      description = "Whether or not the system is a ${toLower role}";
    };
  mkRoleOpts = roles: (listToAttrs (map (role: {
      name = "is${role}";
      value = mkRole role;
    })
    roles));
in {
  options.roles = mkRoleOpts [
    "Laptop"
    "Desktop"
    "Phone"
    "Server"
  ];
}
