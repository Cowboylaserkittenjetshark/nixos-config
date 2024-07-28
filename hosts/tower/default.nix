{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/server.nix
    # Using ancient gpu :/
    ../../modules/hardware/bonaire.nix
    ../../modules/homelab
    ../../modules/network/vpns.nix
    ../../modules/network/tailscale/server.nix
    ../../modules/services/octoprint.nix
  ];

  networking = {
    hostName = "tower";
    useNetworkd = true;
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    nameservers = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
    ];
  };

  systemd.network = {
    enable = true;
    networks."20-wired" = {
      matchConfig.Name = "enp34s0";
      networkConfig = {
        Address = "192.168.86.198/24";
        Gateway = "192.168.86.1";
      };
    };
  };

  services.resolved = {
    enable = true;
    dnsovertls = "true";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  desktopAssets = {
    wallpaper = ../amusementpark.png;
    lockscreen = ../amusementpark.png;
  };

  homelab = {
    enable = true;
    domain = "cblkjs.com";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
