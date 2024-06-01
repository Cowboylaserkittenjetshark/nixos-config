{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-plymouth";
  version = "unstable-2023-6-28";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "plymouth";
    rev = "e13c348a0f47772303b2da1e9396027d8cda160d";
    hash = "sha256-6DliqhRncvdPuKzL9LJec3PJWmK/jo9BrrML7g6YcH0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth
    cp -r themes $out/share/plymouth/

    for i in frappe latte macchiato mocha; do
    	cat themes/catppuccin-$i/catppuccin-$i.plymouth | sed "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/catppuccin-$i/catppuccin-$i.plymouth
    done

    runHook postInstall
  '';

  meta = {
    description = "Soothing pastel theme for Plymouth";
    homepage = "https://github.com/catppuccin/plymouth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [fufexan cowboylaserkittenjetshark];
    platforms = lib.platforms.linux;
  };
}
