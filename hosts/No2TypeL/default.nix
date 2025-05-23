{
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ../../nixosModules/hardware/ft232h.nix
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

  hardware.bluetooth.enable = true;

  services = {
    actkbd = {
      enable = true;
      bindings = [
        {
          keys = [ 224 ];
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -U 10";
        }
        {
          keys = [ 225 ];
          events = [ "key" ];
          command = "/run/current-system/sw/bin/light -A 10";
        }
      ];
    };
    fwupd.enable = true;
    blueman.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    # Required by IWD to decrypt 802.1x EAP-TLS TLS client keys
    kernelModules = [ "pkcs8_key_parser" ];
  };

  impermanence = {
    enable = true;
    persistPath =
      config.disko.devices.disk.main.content.partitions.luks.content.content.subvolumes."/persist".mountpoint;
    cryptDeviceName = config.disko.devices.disk.main.content.partitions.luks.content.name;
  };

  networking.hostName = "No2TypeL";

  systemd.network.networks."20-main".matchConfig.Name = "wlan0";

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

  time.timeZone = "America/New_York";

  gaming.enable = true;

  system.stateVersion = "23.11";
}
