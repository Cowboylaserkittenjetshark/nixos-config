{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/nix-on-droid.nix
  ];
  systemAttributes.roles.phone = true;
  user.shell = "${pkgs.zsh}/bin/zsh";
  home-manager = {
    config = _: {
      system.os = "Nix-on-Droid";
      home.stateVersion = "23.05";
      imports = [
        ../../users/cblkjs/homeManagerModules/shell
        ../../users/cblkjs/homeManagerModules/catppuccin.nix
        ../../users/cblkjs/homeManagerModules/helix.nix
        ../../users/cblkjs/homeManagerModules/git.nix
        ../../users/cblkjs/homeManagerModules/zoxide.nix
        ../../users/cblkjs/homeManagerModules/bat.nix
      ];
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
  };
  environment.etcBackupExtension = ".bak";
  system.stateVersion = "23.11";
}
