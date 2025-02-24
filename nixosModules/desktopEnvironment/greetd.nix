{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.systemAttributes.graphical {
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${
          if config.systemAttributes.roles.laptop
          then "niri"
          else "Hyprland"
        }";
      };
    };
  };
}
