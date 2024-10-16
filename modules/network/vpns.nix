{lib, config, ...}: let
  cfg = config.vpns;
  servers = {
    windscribe = {
      "Dallas Ranch" = {
        wireguard = {
          interface = {
            address = "100.67.252.231";
            dns = "10.255.255.1";
          };
          peer = {
            allowedIPs = ["0.0.0.0/0" "::/0"];
            endpoint = "dfw-86-wg.whiskergalaxy.com:443";
          };
        };
      };
    };
  };
  inherit (lib) types mkOption mkEnableOption mkIf;
  inherit (builtins) attrNames getAttr;
  mkWGSecret = path: {
        file = path;
        mode = "400";
        owner = "systemd-network";
    
  };
in {
  options.vpns = {
    windscribe = {
      wireguard = {
        enable = mkEnableOption "a windscribe wireguard tunnel.";
        keyPair = {
          privateKeyFile = mkOption {
            description = "Path to the file containing the private key.";
            type = types.path;
            default = null;
          };
          peer = {
            publicKey = mkOption {
              description = "The peer's public key.";
              type = types.str;
              default = null;
            };
            presharedKeyFile = mkOption {
              description = "Path to the file containing the preshared key";
              type = types.path;
              default = null;
            };
          };
        };
        server = mkOption {
          description = "The server to connect to.";
          type = types.enum (attrNames servers.windscribe);
          default = null;
        };
      };
      openvpn = {
        enable = mkEnableOption "windscribe openvpn tunnels.";
        autoStart = mkOption {
          description = ''
            The name of the tunnel to autostart.
            If no tunnel is specified, no tunnel will autostart but they will all remain available to start manually.
          '';
          type = types.str;
          default = null;
        };
      };
    };
  };

  config = {
    services.openvpn.servers = mkIf cfg.windscribe.openvpn.enable {
      Windscribe-Atlanta-Mountain = {
        config = ''
          config ${config.age.secrets.Windscribe-Atlanta-Mountain-conf.path}

          auth-user-pass ${config.age.secrets.Windscribe-Atlanta-Mountain-auth.path}
          route 10.64.0.0 255.192.0.0 net_gateway
        '';
        autoStart = false;
      };
      Windscribe-WashingtonDC-Precedent = {
        config = ''
          config ${config.age.secrets.Windscribe-WashingtonDC-Precedent-conf.path}

          auth-user-pass ${config.age.secrets.Windscribe-WashingtonDC-Precedent-auth.path}
          route 10.64.0.0 255.192.0.0 net_gateway
        '';
        autoStart = false;
      };
      Windscribe-Dallas-Ranch = {
        config = ''
          config ${config.age.secrets.Windscribe-Dallas-Ranch-conf.path}

          auth-user-pass ${config.age.secrets.Windscribe-Dallas-Ranch-auth.path}
          route 10.64.0.0 255.192.0.0 net_gateway
        '';
        autoStart = false;
      };
    };

    systemd.network = let 
      wgcfg = cfg.windscribe.wireguard;
    in mkIf wgcfg.enable {
      netdevs."99-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };

        wireguardConfig = {
          PrivateKeyFile = wgcfg.keyPair.privateKeyFile;
          FirewallMark = 8888;
        };

        wireguardPeers = [
          {
            Endpoint = (getAttr wgcfg.server servers.windscribe).wireguard.peer.endpoint;
            AllowedIPs = (getAttr wgcfg.server servers.windscribe).wireguard.peer.allowedIPs;
            PublicKey = wgcfg.keyPair.peer.publicKey;
            PresharedKeyFile = wgcfg.keyPair.peer.presharedKeyFile;
            PersistentKeepalive = 25;
          }
        ];
      };
      networks."50-wg0" = {
        matchConfig.Name = "wg0";
        networkConfig = {
          Address = "${(getAttr wgcfg.server servers.windscribe).wireguard.interface.address}/32";
          DNS = (getAttr wgcfg.server servers.windscribe).wireguard.interface.dns;
          DNSDefaultRoute = true;
          Domains = "~.";
          IPv6AcceptRA = false;
        };

        routingPolicyRules = [
          {
            FirewallMark = 8888;
            InvertRule = true;
            Table = 1000;
            Priority = 10;
          }
          # Exclude the endpoint address
          {
            To = (getAttr wgcfg.server servers.windscribe).wireguard.interface.address;
            Priority = 5;
          }
          # Exclude tailscale addresses
          {
            To = "100.109.116.3";
            Table = 52;
            Priority = 9;
          }
          {
            To = "100.72.92.2";
            Table = 52;
            Priority = 9;
          }
          {
            To = "100.100.100.100";
            Table = 52;
            Priority = 9;
          }
        ];

        routes = [
          {
            Destination = "0.0.0.0/0";
            Table = 1000;
          }
        ];
      };
    };
  
    age.secrets = {
      Windscribe-Atlanta-Mountain-conf = {
        file = ../../secrets/Windscribe-Atlanta-Mountain-conf.age;
        mode = "400";
      };
      Windscribe-Atlanta-Mountain-auth = {
        file = ../../secrets/Windscribe-Atlanta-Mountain-auth.age;
        mode = "400";
      };
      Windscribe-WashingtonDC-Precedent-conf = {
        file = ../../secrets/Windscribe-WashingtonDC-Precedent-conf.age;
        mode = "400";
      };
      Windscribe-WashingtonDC-Precedent-auth = {
        file = ../../secrets/Windscribe-WashingtonDC-Precedent-auth.age;
        mode = "400";
      };
      Windscribe-Dallas-Ranch-conf = {
        file = ../../secrets/Windscribe-Dallas-Ranch-conf.age;
        mode = "400";
      };
      Windscribe-Dallas-Ranch-auth = {
        file = ../../secrets/Windscribe-Dallas-Ranch-auth.age;
        mode = "400";
      };
      windscribe-wg-kp1-pk = mkWGSecret ../../secrets/vpns/windscribe/wireguard/keypair_1/pk.age;
      windscribe-wg-kp1-peer_psk = mkWGSecret ../../secrets/vpns/windscribe/wireguard/keypair_1/peer_psk.age;
      windscribe-wg-kp2-pk = mkWGSecret ../../secrets/vpns/windscribe/wireguard/keypair_2/pk.age;
      windscribe-wg-kp2-peer_psk = mkWGSecret ../../secrets/vpns/windscribe/wireguard/keypair_2/peer_psk.age;
    };
  };
}
