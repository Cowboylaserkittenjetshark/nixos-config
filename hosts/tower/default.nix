{
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    # Using ancient gpu :/
    ../../nixosModules/hardware/bonaire.nix
  ];

  systemAttributes = {
    roles = {
      server = true;
      desktop = true;
    };
    capabilities = [
      "audio"
      "wired-lan"
    ];
  };

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
    vpnAccess = {
      enable = true;
      interface = "tailscale0";
      address = "100.109.116.3";
    };
  };

  services.openssh.vpnAccess = {
    enable = true;
    interface = "tailscale0";
  };

  programs.nh = lib.mkForce {
    enable = true;
    flake = "/home/cblkjs/nixos-config";
  };

  gaming.enable = true;

  services.fstrim.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
