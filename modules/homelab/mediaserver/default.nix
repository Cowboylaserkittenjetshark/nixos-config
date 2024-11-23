{
  lib,
  config,
  ...
}: let
  cfg = config.homelab.mediaserver;
  inherit (lib) mkOption types mkIf listToAttrs toInt;
  apps = [
    {
      name = "prowlarr";
      port = "9696";
    }
    {
      name = "sonarr";
      port = "8989";
    }
    {
      name = "bazarr";
      port = "6767";
    }
    {
      name = "qbittorrent";
      port = "8080";
    }
    {
      name = "jellyfin";
      port = "8096";
    }
    {
      name = "jellyseerr";
      port = "5055";
    }
  ];
in {
  imports = [
    ./qbittorrent.nix
    ./bazarr.nix
  ];

  options.homelab.mediaserver = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "a mediaserver stack (*arrs, qbittorrent, etc.)";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/mediaserver";
      description = "The base directory where applications will store the media library and supporting data";
    };

    dataDirMode = mkOption {
      type = types.str;
      default = "0775";
      description = "The file access mode to use when initializing dataDir";
    };

    user = mkOption {
      type = types.str;
      default = "mediaserver";
      description = "User account under which the media server services run.";
    };

    group = mkOption {
      type = types.str;
      default = "mediaserver";
      description = "Group under which the media server services run.";
    };
  };

  config = mkIf (cfg.enable && config.homelab.enable) {
    services = {
      prowlarr.enable = true;
      sonarr = {
        enable = true;
        inherit (cfg) user group;
      };
      radarr.enable = false;
      bazarr = {
        enable = true;
        inherit (cfg) user group;
      };
      lidarr.enable = false;
      flaresolverr.enable = false;
      qbittorrent = {
        enable = true;
        inherit (cfg) user group;
      };
      jellyfin = {
        enable = true;
        inherit (cfg) user group;
      };
      jellyseerr = {
        enable = true;
        inherit (cfg) user group;
      };
    };

    users = {
      users.${cfg.user} = {
        inherit (cfg) group;
        isSystemUser = true;
        home = "${cfg.dataDir}/home";
        createHome = true;
      };
      groups.${cfg.group}.members = [
        "prowlarr"
      ];
    };

    system.activationScripts.initMediaServer = lib.stringAfter ["var"] ''
      # Create data directory if it doesn't exist
      install -d -m ${cfg.dataDirMode} -g ${cfg.group} \
        ${cfg.dataDir} \
        ${cfg.dataDir}/media \
        ${cfg.dataDir}/media/tv \
        ${cfg.dataDir}/media/movies \
        ${cfg.dataDir}/usenet \
        ${cfg.dataDir}/torrents
    '';

    services.caddy.virtualHosts = listToAttrs (
      map
      (app: {
        name = "${app.name}.${config.homelab.domain}";
        value.extraConfig = ''
          import localOnly
          reverse_proxy 127.0.0.1:${app.port}
        '';
      })
      apps
    );

    networking.hosts."127.0.0.1" = map (app: "${app.name}.${config.homelab.domain}") apps;
    networking.firewall.interfaces = mkIf config.homelab.vpnAccess.enable {${config.homelab.vpnAccess.interface}.allowedTCPPorts = map (app: toInt app.port) apps;};
  };
}
