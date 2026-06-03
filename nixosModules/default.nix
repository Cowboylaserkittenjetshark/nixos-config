{ pkgs, config, ... }: let
  inherit (config.systemAttributes) roles;
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
    ./systemAttributes.nix
    ./users.nix
    ./shell
    ./silent.nix
  ];

  services.upower.enable = true;
  users.mutableUsers = false;
  boot = {
    silent = roles.laptop || roles.desktop;
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

  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    acpi
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = [ pkgs.sarasa-gothic ];
  };
}
