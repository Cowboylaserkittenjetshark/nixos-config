{pkgs, ...}: {
  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://vw.cblkjs.com";
      email = "cowboylaserkittenjetshark@gmail.com";
      lock_timeout = 300;
      pinentry = pkgs.pinentry-tty;
    };
  };
}
