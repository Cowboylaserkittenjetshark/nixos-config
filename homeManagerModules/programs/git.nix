{ config, ... }:
{
  programs.git = {
    enable = true;
    userName = "Cowboylaserkittenjetshark";
    userEmail = "82691052+Cowboylaserkittenjetshark@users.noreply.github.com";
    signing = {
      key = "~/.ssh/${config.programs.ski.settings.roles.sign.target}.pub";
      signByDefault = true;
    };
    iniContent.gpg.format = "ssh";
  };
}
