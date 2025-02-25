_: {
  programs.git = {
    enable = true;
    userName = "Cowboylaserkittenjetshark";
    userEmail = "82691052+Cowboylaserkittenjetshark@users.noreply.github.com";
    signing = {
      key = "~/.ssh/id_ed25519_sk.pub";
      signByDefault = true;
    };
    iniContent.gpg.format = "ssh";
  };
}
