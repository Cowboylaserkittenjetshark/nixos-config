{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/server.nix
    # Using ancient nvidia gpu :/
    ../../modules/hardware/nvidia.nix
    ../../modules/network/vpns.nix
    ../../modules/network/tailscale/server.nix
    inputs.disko.nixosModules.disko
    ./disk-config.nix
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # For lanzaboote (later)
  # boot.loader.systemd-boot.enable = lib.mkForce false;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/etc/secureboot";
  # };

  impermanence = {
    enable = true;
    persistPath = config.disko.devices.disk.main.content.partitions.luks.content.content.subvolumes."/persist".mountpoint;
    cryptDeviceName = config.disko.devices.disk.main.content.partitions.luks.content.name;
  };

  networking = {
    hostName = "No2TypeT";
    useNetworkd = true;
    nftables.enable = true;
    firewall.enable = true;
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
      };
    };
    nameservers = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
    ];
  };

  systemd.network = {
    enable = true;
    networks = {
      "20-wireless" = {
        matchConfig.Name = "wlan0";
        networkConfig = {
          Address = "192.168.86.199/24";
          Gateway = "192.168.86.1";
          IgnoreCarrierLoss = "3s";
        };
      };
    };
  };

  services.resolved = {
    enable = true;
    dnsovertls = "true";
  };

  time.timeZone = "America/New_York";

  desktopAssets = {
    wallpaper = ../amusementpark.png;
    lockscreen = ../amusementpark.png;
  };

  system.stateVersion = "23.11";
}
