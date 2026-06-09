{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  xbacklight = lib.getExe' pkgs.acpilight "xbacklight";
in
{
  imports = [
    ./disk-config.nix
    ../../nixosModules/hardware/ft232h.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  hardware = {
    facter.reportPath = ./facter.json;
    acpilight.enable = true;
    bluetooth.enable = true;
  };

  # For acpilight
  users.groups.video = { };

  services = {
    actkbd = {
      enable = true;
      bindings = [
        {
          keys = [ 224 ];
          events = [ "key" ];
          command = "${xbacklight} -dec 10 -fps 60";
        }
        {
          keys = [ 225 ];
          events = [ "key" ];
          command = "${xbacklight} -inc 10 -fps 60";
        }
      ];
    };
    fwupd.enable = true;
    upower.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
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

  desktopEnvironment.enable = true;
  
  gaming.enable = true;

  system.stateVersion = "23.11";
}
