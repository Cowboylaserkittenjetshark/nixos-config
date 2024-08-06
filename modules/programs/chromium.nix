{lib, config, ...}: {
  config = mkIf config.systemAttributes.graphical {
    programs.chromium = {
      enable = true;
      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = ["en-US"];
      };
    };
  };
}
