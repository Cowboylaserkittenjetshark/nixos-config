{ machine-name, ... }: {
  imports = [];
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = [ "net.ifnames=0" ];
  };
  networking = {
    hostName = machine-name;
    defaultGateway = "10.0.0.1";
    # Use Quad9's DNS (or replace by your preferred DNS provider)
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          # Use IP address configured in the Oracle Cloud web interface
          address = "10.0.0.90";
          prefixLength = 24;
        }
      ];
      # Only "required" for IPv6, can be false if only IPv4 is needed
      useDHCP = true;
    };
    # Note: you also need to configure open ports in the Oracle Cloud web interface
    # (Virtual Cloud Network -> Security Lists -> Ingress Rules)
    firewall = {
      # (both optional)
      logRefusedConnections = false;
      rejectPackets = true;
    };
  };
}
