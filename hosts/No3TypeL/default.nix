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
    ../../nixosModules/hardware/nvidia.nix
  ];

  systemAttributes = {
    roles = {
      laptop = true;
      server = true;
    };
    capabilities = [
      "audio"
      "bluetooth"
      "wireless-lan"
      "wired-lan"
    ];
  };

  hardware.bluetooth.enable = true;

  hardware.nvidia.prime = {
    sync.enable = true;
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services = {
    fwupd.enable = true;
    blueman.enable = true;
    tailscale.authKeyFile = "/persist/secrets/tailscaleAuthKey";
  };

  # Required by IWD to decrypt 802.1x EAP-TLS TLS client keys
  boot.kernelModules = [ "pkcs8_key_parser" ];

  impermanence = {
    enable = true;
    persistPath =
      config.disko.devices.disk.main.content.partitions.luks.content.content.subvolumes."/persist".mountpoint;
    cryptDeviceName = config.disko.devices.disk.main.content.partitions.luks.content.name;
  };

  networking.hostName = "No3TypeL";

  systemd.network.networks."20-main".matchConfig.Name = "wlan0";

  vpns.windscribe = {
    wireguard = {
      enable = true;
      hostileNetworks = true;
      server = "Dallas Ranch";
      keyPair = 2;
      autoStart = false;
    };
    openvpn.enable = false;
  };

  time.timeZone = "America/New_York";

  gaming.enable = true;

  services.openssh.vpnAccess = {
    enable = true;
    interface = "tailscale0";
  };

  system.stateVersion = "24.11";
}
