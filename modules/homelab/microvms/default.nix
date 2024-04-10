{inputs, config, ...}: {
  imports = [
    inputs.microvm.nixosModules.host
    ./caddy.nix
  ];

  options = {};

  config = {
    systemd.network = {
      netdevs."10-microvm".netdevConfig = {
        Kind = "bridge";
        Name = "microvm";
      };
      networks = {
        "10-microvm" = {
          matchConfig.Name = "microvm";
          networkConfig = {
            DHCPServer = false;
            # IPv6SendRA = true;
          };
          addresses = [
            {addressConfig.Address = "192.168.86.200/24";}
            # {addressConfig.Address = "fd12:3456:789a::1/64";}
          ];
          # ipv6Prefixes = [ {ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64";} ];
        }; 
        "11-microvm" = {
          matchConfig.Name = [ "vm-*" ];
          # Attach to the bridge that was configured above
          networkConfig.Bridge = "microvm";
        };
      };
    };
    # For DHCP
    # networking.firewall.allowedUDPPorts = [ 67 ];
    networking.firewall.allowedTCPPorts = [ 22 80 443 ];
    networking.firewall.enable = false;
    networking.nat = {
      enable = true;
      # enableIPv6 = true;
      # Change this to the interface with upstream Internet access
      externalInterface = "enp34s0";
      internalInterfaces = [ "microvm" ];
      forwardPorts = [
        {
          proto = "tcp";
          sourcePort = 80;
          destination = "192.168.86.201:80";
        }
        {
          proto = "tcp";
          sourcePort = 443;
          destination = "192.168.86.201:443";
        }
        {
          proto = "tcp";
          sourcePort = 22;
          destination = "192.168.86.201:22";
        }
      ];
    };
  };
}
