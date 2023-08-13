{ lib, stdenvNoCC, fetchFromGitHub, ... }:
stdenvNoCC.mkDerivation {
  pname = "catppuccin-plymouth";
  version = "unstable-2023-6-28";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "plymouth";
    rev = "27efc6c2a99f70086f40c2df4e28c34e762a42c4";
    hash = "sha256-e3vDwFodxsQAZd2Rm5wGHoqT8D1l18YExA9Dl3o1204=";
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
    maintainers = with lib.maintainers; [ fufexan cowboylaserkittenjetshark ];
    platforms = lib.platforms.linux;
  };
}
