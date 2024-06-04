{...}: {
  programs.chromium = {
    enable = true;
    extensions = [
      # uBlock Origin
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
      # Bitwarden
      {id = "nngceckbapebfimnlniiiahkandclblb";}
      # Dark Reader
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
      # Catppuccin Mocha Theme
      {id = "bkkmolkhemgaeaeggcmfbghljjjoofoh";}
    ];
  };
}
