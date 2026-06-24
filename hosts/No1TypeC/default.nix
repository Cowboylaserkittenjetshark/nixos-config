{ machineName, lib, ... }: {
  imports = [
    ./disk-config.nix
  ];
  hardware.facter.reportPath = ./facter.json;
  # Temporary
  users.users.cblkjs = {
    hashedPasswordFile = lib.mkForce null;
    hashedPassword = "$y$j9T$VodlM3jSPu.dWU6i3TSBD/$uRQM5HT4nyKTn11TeduRZCdo8om5s/76bU/PELkmtj9";
    openssh.authorizedKeys.keys = [ "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBmE5bXrxz9i6X6OaXG28ACvAj0qGVXwKICdhz953uRwAAAABHNzaDo= ssh:" ];
  };
  services.openssh.enable = true;
  boot.kernelParams = [ "net.ifnames=0" ];
  networking = {
    defaultConfig = false;
    hostName = machineName;
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
          address = "10.0.0.75";
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
      allowedTCPPorts = [ 22 ];
    };
  };
}
