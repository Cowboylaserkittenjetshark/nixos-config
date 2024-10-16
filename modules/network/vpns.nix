{config, ...}: let
  # vpns = {
  #   "Dallas Ranch" = {
  #     wireguard = {
  #       interface = {
  #         address = "100.67.252.231/32";
  #         dns = "10.255.255.1";
  #       };
  #       peer = {
  #         allowedIPs = ["0.0.0.0/0" "::/0"];
  #         endpoint = "dfw-86-wg.whiskergalaxy.com:443";
  #       };
  #     };
  #   };
  # };
  mkWGSecret = path: {
        file = path;
        mode = "400";
        owner = "systemd-network";
    
  };
in {
  config = {
    services.openvpn.servers = {
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

    systemd.network = {
      netdevs."99-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          # MTUBytes = 1300; # Why tho?
        };

        wireguardConfig = {
          # ListenPort = 443; # Why?
          PrivateKeyFile = config.age.secrets.windscribe-wg-kp1-pk.path;
          FirewallMark = 8888; # # But why?
        };

        wireguardPeers = [
          {
            Endpoint = "dfw-86-wg.whiskergalaxy.com:443";
            AllowedIPs = ["0.0.0.0/0" "::/0"];
            PublicKey = "pASG4FD9LwOfJukT/wYbUF10gD6v8DVuv5hrNbiOnHQ="; # This is for kp1 only
            PresharedKeyFile = config.age.secrets.windscribe-wg-kp1-peer_psk.path;
            PersistentKeepalive = 25;
          }
        ];

      };
      networks."50-wg0" = {
        matchConfig.Name = "wg0";
        networkConfig = {
          Address = "100.67.252.231/32";
          DNS = "10.255.255.1";
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
            To = "100.67.252.231";
            Priority = 5;
          }
          # Exclude tailscale addresses
          # Ranges overlap >:(
          # {
          #   To = "100.64.0.0/10";
          #   Priority = 9;
          # }
          # {
          #   To = "fd7a:115c:a1e0::/48";
          #   Priority = 9;
          # }
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
