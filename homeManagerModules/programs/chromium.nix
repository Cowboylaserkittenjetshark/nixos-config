{ inputs, pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.Ev357.helium;
    commandLineArgs = [ "--password-store=basic" ];
    extensions = [
      # Bitwarden
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      # Dark Reader
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      # Zotero Connector
      { id = "ekhagklcjbdpajgpjgmbionohlpdbjgc"; }
    ];
  };
}
