{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf toInt getExe getExe' splitString;
  inherit (builtins) attrNames getAttr toString concatStringsSep listToAttrs;

  cfg = config.vpns;

  servers = {
    windscribe = let 
      DNS = "10.255.255.1";
      AllowedIPs = ["0.0.0.0/0" "::/0"];
    in {
      "Dallas Ranch".wireguard = {
        Address = "100.67.252.231";
        Endpoint = "dfw-86-wg.whiskergalaxy.com:443";
        inherit AllowedIPs DNS;
      };
      "Atlanta Mountain".wireguard = {
        Address = "100.80.105.61";
        Endpoint = "atl-109-wg.whiskergalaxy.com:443";
        inherit AllowedIPs DNS;
      };
      "WashingtonDC Precedent" = {};
    };
  };

  keyPairs = let
    inherit (config.age) secrets;
  in {
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

  mkOVPNSecret = path: {
    file = path;
    mode = "400";
  };

  mkWGSecret = path: {
    file = path;
    mode = "400";
    owner = "systemd-network";
  };

  hyphenateServerName = serverName: concatStringsSep "-" (splitString " " serverName);

  genOvpnServer = serverName: {
    config = let
      hyphenatedServerName = hyphenateServerName serverName;
    in ''
      config ${(getAttr "Windscribe-${hyphenatedServerName}-conf" config.age.secrets).path}

      auth-user-pass ${(getAttr "Windscribe-${hyphenatedServerName}-auth" config.age.secrets).path}
      route 10.64.0.0 255.192.0.0 net_gateway
    '';
    autoStart = cfg.windscribe.openvpn.autoStart == serverName;
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
        autoStart = mkEnableOption "automatically starting the wireguard tunnel";
      };
      openvpn = {
        enable = mkEnableOption "windscribe openvpn tunnels.";
        autoStart = mkOption {
          description = ''
            The name of the tunnel to autostart.
            If no tunnel is specified, no tunnel will autostart but they will all remain available to start manually.
          '';
          type = types.str;
          default = "";
        };
      };
    };
  };

  config = {
    services.openvpn.servers = mkIf cfg.windscribe.openvpn.enable (listToAttrs (map (serverName: {
      name = "Windscribe-${hyphenateServerName serverName}";
      value = genOvpnServer serverName;
    }) (attrNames servers.windscribe)));

    systemd = let
      keyPair = getAttr (toString wgcfg.keyPair) keyPairs;
      wgcfg = cfg.windscribe.wireguard;
      server = (getAttr wgcfg.server servers.windscribe).wireguard;
    in {
      services.wireguard-autostart = mkIf wgcfg.autoStart {
        unitConfig = {
          Description = "Automatically bring up wireguard tunnel";
          Wants = ["network-online.target"];
          After = ["network-online.target" "nss-lookup.target"];
        };
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = pkgs.writeShellScript "wireguard-autostart" ''
            until ${getExe pkgs.dig} +tries=1 +timeout=1 nixos.org; do
                sleep 1
            done
            ${getExe' pkgs.systemd "networkctl"} up wg0
          '';
        };
      };
      network = mkIf wgcfg.enable {
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
              inherit (server) Endpoint AllowedIPs;
              PersistentKeepalive = 25;
            }
          ];
        };
        networks."50-wg0" = {
          matchConfig.Name = "wg0";
          networkConfig = {
            Address = "${server.Address}/32";
            inherit (server) DNS;
            DNSDefaultRoute = true;
            Domains = "~.";
            IPv6AcceptRA = false;
          };

          # DNS must be available to resolve the endpoint domain, so we bring the interface up later with a service
          # See the wireguard-autostart service defined above
          linkConfig.ActivationPolicy = "down";

          routingPolicyRules = [
            {
              FirewallMark = 8888;
              InvertRule = true;
              Table = 1000;
              Priority = 10;
            }
            # Exclude the endpoint address
            {
              To = server.Address;
              Priority = 5;
            }
            # Exclude tailscale addresses
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
