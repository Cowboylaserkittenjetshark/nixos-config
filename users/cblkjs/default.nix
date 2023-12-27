{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/zsh.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.cblkjs = import ./home.nix;
  home-manager.extraSpecialArgs = {inherit inputs;};

  users.users.cblkjs = {
    initialPassword = "password";
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      firefox
      foot
      prismlauncher
    ];
  };
}
