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
    hostName = "lap"; # Define your hostname.
    nameservers = ["127.0.0.1" "::1"];
    networkmanager = {
      wifi = {
        backend = "iwd";
        powersave = true;
      };
      enable = true;
      dns = "none";
    };
  };

  services.stubby = {
    enable = true;
    settings =
      pkgs.stubby.passthru.settingsExample
      // {
        listen_addresses = [
          "127.0.0.1@53000"
          "0::1@53000"
        ];
        upstream_recursive_servers = [
          {
            address_data = "9.9.9.9";
            tls_auth_name = "dns.quad9.net";
            tls_pubkey_pinset = [
              {
                digest = "sha256";
                value = "/SlsviBkb05Y/8XiKF9+CZsgCtrqPQk5bh47o0R3/Cg=";
              }
            ];
          }
          {
            address_data = "149.112.112.112";
            tls_auth_name = "dns.quad9.net";
            tls_pubkey_pinset = [
              {
                digest = "sha256";
                value = "/SlsviBkb05Y/8XiKF9+CZsgCtrqPQk5bh47o0R3/Cg=";
              }
            ];
          }
        ];
      };
  };
  services.dnsmasq = {
    enable = true;
    settings = {
      no-resolv = true;
      proxy-dnssec = true;
      server = [
        "127.0.0.1#53000"
        "::1#53000"
      ];
      listen-address = "::1,127.0.0.1";
    };
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
