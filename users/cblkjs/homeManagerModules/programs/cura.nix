# Based on https://gist.github.com/Force67/d9bb6acb37d9febf8554fa87dc916afe
{
  inputs,
  pkgs,
  ...
}: let
  cura5 = pkgs.appimageTools.wrapType2 {
    pname = "cura5";
    version = "5.9.0";
    src = inputs.cura;
  };

  curaLauncher = pkgs.writeShellScriptBin "cura" ''
    # AppImage version of Cura loses current working directory and treats all paths relative to $HOME.
    # So we convert each of the files passed as argument to an absolute path.
    # This fixes use cases like `cd /path/to/my/files; cura mymodel.stl anothermodel.stl`.
    args=()
    for a in "$@"; do
      if [ -e "$a" ]; then
        a="$(realpath "$a")"
      fi
      args+=("$a")
    done
    exec "${cura5}/bin/cura5" "''${args[@]}"
  '';

  curaDesktopEntry = ''
    [Desktop Entry]
    Version=1.0
    Name=Cura
    Comment=Cura 3D Printing Software
    Exec=${curaLauncher}/bin/cura %f
    Icon=cura
    Terminal=false
    Type=Application
    Categories=Graphics;3DGraphics;
  '';
in {
  home.packages = [
    curaLauncher
  ];

  home.file = {
    ".local/share/applications/cura.desktop".text = curaDesktopEntry;
  };
}
