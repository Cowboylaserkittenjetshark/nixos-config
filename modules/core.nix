{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./nix
    ./impermanence
    ./services/pipewire.nix
  ];

  services.upower.enable = true;
  users.mutableUsers = false;
  security.rtkit.enable = true;
  boot = {
    # Enable systemd in phase 1. Used for unlocking root partition with FIDO2/TPM
    initrd.systemd.enable = true;
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = {
        enable = true;
        # Limit the number of generations to keep
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];
}
