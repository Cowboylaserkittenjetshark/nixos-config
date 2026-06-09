{ lib, ... }:
let
  vpnAccess = {
    enable = true;
    interface = "tailscale0";
    address = "100.109.116.3";
  };
in
{
  imports = [
    # Using ancient gpu :/
    ../../nixosModules/hardware/bonaire.nix
  ];

  hardware.facter.reportPath = ./facter.json;

  desktopEnvironment.enable = true;

  networking.hostName = "tower";

  systemd.network.networks."20-main".matchConfig.Name = "enp34s0";

  vpns.windscribe = {
    wireguard = {
      enable = true;
      hostileNetworks = true;
      server = "Dallas Ranch";
      keyPair = 1;
      autoStart = true;
    };
    openvpn.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  homelab = {
    enable = true;
    domain = "cblkjs.com";
    inherit vpnAccess;
  };

  services = {
    fstrim.enable = true;
    openssh = {
      enable = true;
      inherit vpnAccess;
    };
    sunshine = {
      enable = true;
      inherit vpnAccess;
    };
  };

  programs.nh = lib.mkForce {
    enable = true;
    flake = "/home/cblkjs/nixos-config";
  };

  gaming.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };
    "/swap" = {
      device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };
    "/var" = {
      device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=var" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/063a79d2-a904-4e52-8579-453570324320";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/F847-0DA6";
      fsType = "vfat";
    };
  };

  boot.initrd.luks.devices."data".device = "/dev/disk/by-uuid/350a7bf9-b1e4-486d-a627-7c5ecc30b6a4";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
