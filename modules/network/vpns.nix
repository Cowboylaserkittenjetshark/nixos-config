{lib, config, ...}: let
  inherit (lib) types mkOption mkEnableOption mkIf toInt;
  inherit (builtins) attrNames getAttr toString;

  cfg = config.vpns;

  servers = {
    windscribe = {
      "Dallas Ranch" = {
        wireguard = {
          interface = {
            Address = "100.67.252.231";
            DNS = "10.255.255.1";
          };
          peer = {
            AllowedIPs = ["0.0.0.0/0" "::/0"];
            Endpoint = "dfw-86-wg.whiskergalaxy.com:443";
          };
        };
      };
      "Atlanta Mountain" = {
        interface = {
          Address = "100.80.105.61";
          DNS = "10.255.255.1";
        };
        peer = {
          AllowedIPs = ["0.0.0.0/0" "::/0"];
          Endpoint = "atl-109-wg.whiskergalaxy.com:443";
        };
      };
    };
  };

  keyPairs = let inherit (config.age) secrets; in {
    "1" = {
      PrivateKeyFile = secrets.windscribe-wg-kp1-pk.path;
      PublicKey = "pASG4FD9LwOfJukT/wYbUF10gD6v8DVuv5hrNbiOnHQ=";
      PresharedKeyFile = secrets.windscribe-wg-kp1-peer_psk.path;
    };
    "2" = {
      PrivateKeyFile = secrets.windscribe-wg-kp2-pk.path;
      PublicKey = "D2Tx/zEgTy2uoH2HLp5EBIFyLkHGEhkhLMYYedpcUFw=";
      PresharedKeyFile = secrets.windscribe-wg-kp2-peer_psk.path;
    };
  };

  getKeyPair = key: getAttr (toString key) keyPairs;

  mkOVPNSecret = path: {
        file = path;
        mode = "400";
  };
  
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
        keyPair = mkOption {
          description = "The keypair to use when connecting to the server. The same keypair cannot be used to make parallel connections to the same server.";
          type = types.enum (map toInt (attrNames keyPairs));
          default = null;
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
      keyPair = getKeyPair wgcfg.keyPair;
      wgcfg = cfg.windscribe.wireguard;
      server = (getAttr wgcfg.server servers.windscribe).wireguard;
    in mkIf wgcfg.enable {
      netdevs."99-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };

        wireguardConfig = {
          inherit (keyPair) PrivateKeyFile;
          FirewallMark = 8888;
        };

        wireguardPeers = [
          {
            inherit (keyPair) PublicKey PresharedKeyFile;
            inherit (server.peer) Endpoint AllowedIPs;
            PersistentKeepalive = 25;
          }
        ];
      };
      networks."50-wg0" = {
        matchConfig.Name = "wg0";
        networkConfig = {
          Address = "${server.interface.Address}/32";
          inherit (server.interface) DNS;
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
            To = server.interface.Address;
            Priority = 5;
          }
          # Exclude tailscale addresses
          # {
          #   To = "100.109.116.3";
          #   Table = 52;
          #   Priority = 9;
          # }
          # {
          #   To = "100.72.92.2";
          #   Table = 52;
          #   Priority = 9;
          # }
          # {
          #   To = "100.100.100.100";
          #   Table = 52;
          #   Priority = 9;
          # }
          {
            To = "100.64.0.0/10";
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
      Windscribe-Atlanta-Mountain-conf = mkOVPNSecret ../../secrets/Windscribe-Atlanta-Mountain-conf.age;
      Windscribe-Atlanta-Mountain-auth = mkOVPNSecret ../../secrets/Windscribe-Atlanta-Mountain-auth.age;
      Windscribe-WashingtonDC-Precedent-conf = mkOVPNSecret ../../secrets/Windscribe-WashingtonDC-Precedent-conf.age;
      Windscribe-WashingtonDC-Precedent-auth = mkOVPNSecret ../../secrets/Windscribe-WashingtonDC-Precedent-auth.age;
      Windscribe-Dallas-Ranch-conf = mkOVPNSecret ../../secrets/Windscribe-Dallas-Ranch-conf.age;
      Windscribe-Dallas-Ranch-auth = mkOVPNSecret ../../secrets/Windscribe-Dallas-Ranch-auth.age;

      windscribe-wg-kp1-pk = mkWGSecret ../../secrets/vpns/windscribe/wireguard/keypair_1/pk.age;
      windscribe-wg-kp1-peer_psk = mkWGSecret ../../secrets/vpns/windscribe/wireguard/keypair_1/peer_psk.age;
      windscribe-wg-kp2-pk = mkWGSecret ../../secrets/vpns/windscribe/wireguard/keypair_2/pk.age;
      windscribe-wg-kp2-peer_psk = mkWGSecret ../../secrets/vpns/windscribe/wireguard/keypair_2/peer_psk.age;
    };
  };
}
