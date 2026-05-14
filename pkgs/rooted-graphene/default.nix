{
  lib,
  fetchgit,
  makeWrapper,
  runCommand,
  # Runtime deps
  android-tools,
  avbroot,
  unzip,
  bash,
}:

let
  src = fetchgit {
    url = "https://github.com/schnatterer/rooted-graphene.git";
    hash = "sha256-CY12dWmf9wosB4x8v98Lw8RFhzColhKtLMaGKiiDGZU=";
  };

  patchFile = ./install-assets.patch;

  binName = "rooted-ota";

  deps = [
    bash
    android-tools
    avbroot
    unzip
  ];
in
runCommand "${binName}"
  {
    nativeBuildInputs = [ makeWrapper ];
    meta = {
      mainProgram = "${binName}";
    };
  }
  ''
    mkdir -p $out/bin
    install ${src}/rooted-ota.sh $out/bin/${binName}
    patch -u $out/bin/${binName} -i ${patchFile}

    wrapProgram $out/bin/${binName} \
      --prefix PATH : ${lib.makeBinPath deps}
  ''
