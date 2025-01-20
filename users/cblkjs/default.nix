{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../common/modules/zsh.nix
    ./modules/services/syncthing.nix
    ./modules/home-manager.nix
  ];

  users.users.cblkjs = {
    hashedPasswordFile = "/persist/secrets/cblkjs-passwd";
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel" "plugdev"];
  };
}
