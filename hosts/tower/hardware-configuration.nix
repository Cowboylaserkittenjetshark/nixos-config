# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  boot.initrd.luks.devices."data".device = "/dev/disk/by-uuid/350a7bf9-b1e4-486d-a627-7c5ecc30b6a4";

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=var" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F847-0DA6";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
