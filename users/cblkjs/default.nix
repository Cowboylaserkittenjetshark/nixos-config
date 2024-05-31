{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../common/modules/zsh.nix
    ./modules/services/syncthing.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.cblkjs = import ./home.nix;
  home-manager.extraSpecialArgs = {inherit inputs;};

  users.users.cblkjs = {
    hashedPasswordFile = "/persist/secrets/cblkjs-passwd";
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
