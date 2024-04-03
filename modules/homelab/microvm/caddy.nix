{ config, ... }: let
  # Def stuff
in
{
  microvm.vms.caddy = {
    autostart = true;
    restartIfChanged = true;
    config = {
      # VM config
      microvm = {
        shares = [
          # Pass through host's store to avoid large images
          {
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
            tag = "ro-store";
            proto = "virtiofs";
          }
        ];
        interfaces = [
          {
            type = "tap";
            id = "vm-caddy";
            mac = "02:fc:b1:f2:1a:73";
          }
        ];
      };
      # Container's nixos config
      system.stateVersion = config.system.nixos.version;
      services.caddy = {
        enable = true;
        virtualHosts.":80".extraConfig = ''
          respond "Hello, world :)"
        '';
      };
      networking = {
        firewall = {
          allowedTCPPorts = [ 22 80 443 ];
          enable = true;
        };
        useNetworkd = true;
        nftables.enable = true;
      };
      systemd.network = {
        enable = true;
        networks."20-lan" = {
          matchConfig.Type= "ether";
          networkConfig = {
            Address = [ "10.0.0.2/24" ];
            Gateway = "10.0.0.1";
            DNS = [ "10.0.0.1" ];
            DHCP = "no";
          };
        };
      };
      # SSH for testing
      users.users.root.password = "";
      services.openssh = {
        enable = true;
        settings.PermitRootLogin = "yes";
      };
    };
  };
}
