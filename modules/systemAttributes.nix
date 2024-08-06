{
  copnfig,
  lib,
  ...
}:
let
  cfg = config.systemAttributes;

  inherit (lib) types mkOption listToAttrs;

  mkRole = role:
    (mkOption {
      type = types.bool;
      default = false;
      description = "Whether or not the system is a ${role}";
    });

  mkRoleOpts = roles: (listToAttrs (map (role: {
      name = "${role}";
      value = mkRole role;
    })
    roles));
in {
  options.systemAttributes = {
    roles = mkRoleOptions [
      "desktop"
      "laptop"
      "phone"
      "server"
    ];

    capabilities = mkOption {
      type = types.listOf (types.enum [
        "fingerprint"
        "bluetooth"
        "audio"
        "wireless-lan"
        "wired-lan"
      ]);
      default = [];
      description "A list of the system's capabilities";
    };
    
    graphical = {
      type = types.bool;
      default = (cf.roles.laptop || cfg.roles.desktop);
      description = "Whether the system has a graphical session";
    };
  };
}
