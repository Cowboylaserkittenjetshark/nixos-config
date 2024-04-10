{inputs, config, ...}: {
  imports = [];

  options = {};

  config = {
    microvm.vms.caddy= {
      autostart = true;
      restartIfChanged = true;
      config = {
        microvm = {
          shares = [
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

        system.stateVersion = config.system.nixos.version;

        services.caddy = {
          enable = true;
          virtualHosts.":80".extraConfig = ''
            respond "Hello, world :)"
          '';
        };
        
        networking.firewall.allowedTCPPorts = [ 80 443 22 ];
        networking.firewall.enable = true;

        systemd.network.enable = true;
        networking.useNetworkd = true;

        systemd.network.networks."20-lan" = {
          matchConfig.Type = "ether";
          networkConfig = {
            Address = ["192.168.86.201/24"];
            Gateway = "192.168.86.1";
            DNS = ["192.168.86.1"];
            # IPv6AcceptRA = true;
            DHCP = "no";
          };
        };
        users.users.root.password = "";
        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
        };
      };
    };
  };
}
