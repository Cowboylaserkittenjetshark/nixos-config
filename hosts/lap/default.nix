{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t420
    ../../modules/core.nix
    ../../modules/sddm.nix
    ../../modules/pam_u2f.nix
    ../../modules/printing.nix
    ../../modules/steam.nix
    ../../modules/tailscale/client.nix
    ../../modules/wayland/hyprland.nix
    ../../modules/gnupg.nix
    ../../modules/desktopAssets.nix
    ../../modules/power.nix
    ../../modules/nix
  ];

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
    };
  };

  services.resolved = {
    enable = true;
    dnsovertls = "true";
    dnssec = "true";
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
