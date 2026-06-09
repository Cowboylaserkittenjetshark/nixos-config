{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.desktopEnvironment.enable {
    programs.chromium = {
      enable = true;
      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [ "en-US" ];
      };
    };
  };
}
