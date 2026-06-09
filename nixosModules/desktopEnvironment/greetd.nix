{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.desktopEnvironment.enable {
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd}/bin/agreety --cmd niri-session";
    };
  };
}
