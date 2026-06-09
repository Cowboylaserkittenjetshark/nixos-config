{ pkgs, ... }: let
in {
  imports = [
    ./authentication
    ./desktopEnvironment
    ./gaming
    ./homelab
    ./impermanence
    ./network
    ./nix
    ./programs
    ./services
    ./stylix
    ./home-manager.nix
    ./users.nix
    ./shell
    ./silent.nix
  ];
  users.mutableUsers = false;
  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
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
    acpi
  ];
}
