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
        default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
      };
    };
  };
}
