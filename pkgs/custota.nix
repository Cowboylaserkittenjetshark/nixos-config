{
  lib,
  fetchgit,
  rustPlatform,
  git,
  breakpointHook,
}: let
    version = "5.22";
in rustPlatform.buildRustPackage (finalAttrs: {
  name = "custota-tool";
  src = fetchgit {
    url = "https://github.com/chenxiaolong/Custota.git";
    rev = "refs/tags/v${version}";
    hash = "sha256-dYIq3Jl9o0SQErmWDr2Fg/kv66TIvpaNJ0uGl9HXwiQ=";
    leaveDotGit = true;
  };

  buildAndTestSubdir = "custota-tool";

  cargoHash = "sha256-Fe6qGGB8JpFfVQdv4pgrSlUv6HeXAM4S9hf86thLMso=";

  nativeBuildInputs = [
    git
    breakpointHook
  ];

  meta = {
    description = "Backend tooling for Custota, an Android A/B OTA updater app for custom OTA servers";
    homepage = "https://github.com/chenxiaolong/Custota";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
