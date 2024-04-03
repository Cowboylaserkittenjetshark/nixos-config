{ lib, inputs, ... }: let
  # Def stuff
in
{
  networking = {
    # Enable wpa_supplicant for the laptop
    wireless = {
      enable = true;
      userControlled.enable = true;
    };
    # Force disable network manager, we're using networkd
    networkmanager.enable = lib.mkForce false;
    # Use nftables instead of iptables 
    nftables.enable = true;
    # Makes networking.* use networkd
    # instead of the script based backend
    useNetworkd = true;
    firewall = {
      allowedTCPPorts = [ 22 80 443 ];
      enable = true;
    };
    # Enable NAT so that VMs can access outside network
    nat = {
      enable = true;
      externalInterface = "eno0";
      internalInterfaces = [ "mvmbr0" ];
      forwardPorts = [
        {
          proto = "tcp";
          sourcePort = 80;
          destination = "10.0.0.2:80";
        }
        {
          proto = "tcp";
          sourcePort = 443;
          destination = "10.0.0.2:443";
        }
        {
          proto = "tcp";
          sourcePort = 22;
          destination = "10.0.0.2:22";
        }
      ];
    };
  };

  systemd.network = {
    # Enable systemd-networkd
    enable = true;
    # Virtual devices
    netdevs = {
      # Configure virtual bridge to attach vms to
      "10-mvmbr0".netdevConfig = {
        Kind = "bridge";
        Name = "mvmbr0";
      };
    };
    networks = {
      # Assign ip addr to the bridge
      "10-microvm" = {
        matchConfig.Name = "mvmbr0";
        networkConfig = {
          DHCPServer = false;
        };
        addresses = [
          { addressConfig.Address = "10.0.0.1/24"; }
        ];
      };
      # Attach vm tap interfaces to the bridge
      "11-microvm" = {
        matchConfig.Name = [ "vm-*" ];
        networkConfig.Bridge = "mvmbr0";
      };
    };
  };
}
