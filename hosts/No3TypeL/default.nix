{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
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

  services = {
    fwupd.enable = true;
    blueman.enable = true;
    tailscale.authKeyFile = "/persist/secrets/tailscaleAuthKey";
  };

  # Required by IWD to decrypt 802.1x EAP-TLS TLS client keys
  boot.kernelModules = ["pkcs8_key_parser"];

  impermanence = {
    enable = true;
    persistPath = config.disko.devices.disk.main.content.partitions.luks.content.content.subvolumes."/persist".mountpoint;
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

  desktopAssets = {
    wallpaper = "${config.age.secrets.Forest-Kingdom-Dithered-Mocha.path}";
    lockscreen = "${config.age.secrets.Amusement-Park2-Dithered-Mocha.path}";
  };

  gaming.enable = true;

  services.openssh.vpnAccess = {
    enable = true;
    interface = "tailscale0";
  };

  system.stateVersion = "24.11";
}
