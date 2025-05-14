_: {
  programs.git = {
    enable = true;
    userName = "Cowboylaserkittenjetshark";
    userEmail = "82691052+Cowboylaserkittenjetshark@users.noreply.github.com";
    signing = {
      key = "~/.ssh/signing_key.pub";
      signByDefault = true;
    };
    iniContent.gpg.format = "ssh";
  };
}
