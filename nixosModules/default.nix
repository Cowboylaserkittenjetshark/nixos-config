{ lib, pkgs, config, ... }: let
  inherit (config.systemAttributes) roles graphical;
  isPC = roles.laptop || roles.desktop;
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

  services.upower.enable = isPC;
  users.mutableUsers = false;
  boot = {
    silent = isPC;
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

  hardware.logitech.wireless.enable = isPC;

  environment.systemPackages = with pkgs; [
    vim
    git
    acpi
  ];

  fonts = lib.mkIf graphical {
    enableDefaultPackages = true;
    packages = [ pkgs.sarasa-gothic ];
  };
}
