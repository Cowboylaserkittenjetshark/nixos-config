{...}:
{
  services.octoprint = {
    enable = true;
    plugins = plugins: with plugins; [
      printtimegenius
      simpleemergencystop
      themeify
      titlestatus
    ];
  };
}
