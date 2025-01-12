{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t420
  ];

  systemAttributes = {
    roles.laptop = true;
    capabilities = [
      "audio"
      "bluetooth"
      "fingerprint"
      "wireless-lan"
      "wired-lan"
    ];
  };

  impermanence = {
    enable = true;
    persistPath = config.disko.devices.disk.main.content.partitions.luks.content.content.subvolumes."/persist".mountpoint;
    cryptDeviceName = config.disko.devices.disk.main.content.partitions.luks.content.name;
  };

  boot.initrd.kernelModules = ["i915"];

  networking = {
    hostName = "lap";
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
    networks."20-wireless" = {
      matchConfig.Name = "wlan0";
      networkConfig = {
        DHCP = "yes";
        IgnoreCarrierLoss = "3s";
      };
      dhcpV4Config.UseDNS = false;
      dhcpV6Config.UseDNS = false;
    };
  };

  services.resolved = {
    enable = true;
    dnsovertls = "true";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.tlp.enable = true;
  services.thermald.enable = true;

  desktopAssets = {
    wallpaper = ../amusementpark.png;
    lockscreen = ../amusementpark.png;
  };

  system.stateVersion = "23.11";
}
