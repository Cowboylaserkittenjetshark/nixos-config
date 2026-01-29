{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [ "--ozone-platform=wayland" ];
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
