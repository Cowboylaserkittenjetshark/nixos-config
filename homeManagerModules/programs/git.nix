{ lib, config, ... }:
{
  programs.git = {
    enable = true;
    settings.user = {
      name = "Cowboylaserkittenjetshark";
      email = "82691052+Cowboylaserkittenjetshark@users.noreply.github.com";
    };
    signing = {
      programs.git.signing.format = "openpgp";
      key = "~/.ssh/${config.programs.ski.settings.roles.sign.target}.pub";
      signByDefault = true;
    };
    iniContent.gpg.format = "ssh";
  };

  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
}
