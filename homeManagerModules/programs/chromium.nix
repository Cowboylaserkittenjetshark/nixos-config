{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      # uBlock Origin
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      # Bitwarden
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      # Dark Reader
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      # Stylus
      { id = "clngdbkpkpeebahjckkjfobafhncgmne"; }
      # Catppuccin Mocha Theme
      { id = "bkkmolkhemgaeaeggcmfbghljjjoofoh"; }
      # Zotero Connector
      { id = "ekhagklcjbdpajgpjgmbionohlpdbjgc"; }
    ];
  };
}
