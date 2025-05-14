_: {
  imports = [
    ./vpns.nix
    ./tailscale.nix
    ./sshd.nix
  ];

  networking = {
    useNetworkd = true;
    nftables.enable = true;
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
      };
    };
    nameservers = [ "127.0.0.55" ];
  };

  systemd.network = {
    enable = true;
    networks."20-main" = {
      networkConfig = {
        DHCP = "yes";
        IgnoreCarrierLoss = "3s";
      };
      dhcpV4Config.UseDNS = false;
      dhcpV6Config.UseDNS = false;
    };
  };

  services = {
    resolved = {
      enable = true;
      dnsovertls = "false"; # Must be off for dnscrypt proxy
      fallbackDns = [ ];
    };

    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        listen_addresses = [ "127.0.0.55:53" ];
        log_level = 0;
      };
    };
  };
}
