{ lib, osConfig, inputs, pkgs, ... }:
{
  programs.chromium = lib.mkIf osConfig.desktopEnvironment.enable {
    enable = true;
    package = inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.lonerOrz.helium;
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
