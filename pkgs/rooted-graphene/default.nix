{
  lib,
  fetchgit,
  makeWrapper,
  runCommand,
  # Runtime deps
  android-tools,
  avbroot,
  unzip,
  curl,
  gawk,
  git,
  openssh,
  docker,
  bash,
}:

let
  src = fetchgit {
    url = "https://github.com/schnatterer/rooted-graphene.git";
    hash = "sha256-acRUbKUhpbedMqYeDqyDYViHiseqwfyn/zhyDbCIUAM=";
  };

  patches = [
    ./install-assets.patch
  ];

  binName = "rooted-ota";

  deps = [
    android-tools
    avbroot
    unzip
    curl
    gawk
    git
    openssh
    docker
    bash
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
    ${lib.concatMapStringsSep "\n" (
      patchFile: "patch --no-backup-if-mismatch -u $out/bin/${binName} -i ${patchFile}"
    ) patches}

    wrapProgram $out/bin/${binName} \
      --prefix PATH : ${lib.makeBinPath deps}
  ''
