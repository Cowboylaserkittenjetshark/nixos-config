{ lib, stdenvNoCC, fetchFromGitHub }:
  stdenvNoCC.mkDerivation rec {
    pname = "sddm-catppuccin-theme";
    version = "unstable-2023-08-08";
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r $src/src/catppuccin-* $out/share/sddm/themes/
    '';
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "7fc67d1027cdb7f4d833c5d23a8c34a0029b0661";
      sha256 = "sha256-SjYwyUvvx/ageqVH5MmYmHNRKNvvnF3DYMJ/f2/L+Go=";
    };
    meta = {
      description = "Soothing pastel theme for SDDM";
      homepage = "https://github.com/catppuccin/sddm";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [cowboylaserkittenjetshark];
      platforms = lib.platforms.linux;
    };
  }
