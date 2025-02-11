{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  systemAttributes = {
    roles.laptop = true;
    capabilities = [
      "audio"
      "bluetooth"
      "fingerprint"
      "wireless-lan"
    ];
  };

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [224];
        events = ["key"];
        command = "/run/current-system/sw/bin/light -U 10";
      }
      {
        keys = [225];
        events = ["key"];
        command = "/run/current-system/sw/bin/light -A 10";
      }
    ];
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  services.fwupd.enable = true;

  impermanence = {
    enable = true;
    persistPath = config.disko.devices.disk.main.content.partitions.luks.content.content.subvolumes."/persist".mountpoint;
    cryptDeviceName = config.disko.devices.disk.main.content.partitions.luks.content.name;
  };

  networking = {
    hostName = "No2TypeL";
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
    networks."20-main" = {
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

  vpns.windscribe = {
    wireguard = {
      enable = true;
      hostileNetworks = true;
      server = "Dallas Ranch";
      keyPair = 2;
      autoStart = true;
    };
    openvpn.enable = true;
  };

  # Required by IWD to decrypt 802.1x EAP-TLS TLS client keys
  boot.kernelModules = ["pkcs8_key_parser"];

  time.timeZone = "America/New_York";

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  desktopAssets = {
    wallpaper = "${config.age.secrets.Forest-Kingdom-Dithered-Mocha.path}";
    lockscreen = "${config.age.secrets.Amusement-Park2-Dithered-Mocha.path}";
  };

  gaming.enable = true;

  system.stateVersion = "23.11";
}
