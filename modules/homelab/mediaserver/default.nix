{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.homelab.mediaserver;
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
      name = "qbittorrent";
      port = "8080";
    }
    {
      name = "jellyfin";
      port = "8096";
    }
  ];
in {
  imports = [
    ./qbittorrent.nix
  ];

  options.homelab.mediaserver = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "a mediaserver stack (*arrs, qbittorrent, etc.)";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/mediaserver";
      description = lib.mdDoc ''
        The base directory where applications will store the media library and supporting data
      '';
    };

    dataDirMode = mkOption {
      type = types.str;
      default = "0775";
      description = lib.mdDoc ''
        The file access mode to use when initializing dataDir
      '';
    };

    group = mkOption {
      type = types.str;
      default = "media";
      description = lib.mdDoc ''
        The group that owns dataDir
      '';
    };
  };

  config = mkIf (cfg.enable && config.homelab.enable) {
    services = {
      prowlarr.enable = true;
      sonarr.enable = true;
      radarr.enable = false;
      bazarr.enable = false;
      lidarr.enable = false;
      flaresolverr.enable = true;
      qbittorrent.enable = true;
      sabnzbd.enable = true;
      jellyfin.enable = true;
    };

    users.groups.${cfg.group}.members = [
      "prowlarr"
      "sonarr"
      # "radarr"
      # "bazarr"
      # "lidarr"
      "qbittorrent"
      "sabnzbd"
    ];

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

    networking = {
      hosts = {
        "127.0.0.1" = map (app: "${app.name}.${config.homelab.domain}") apps;
      };
      firewall.interfaces.${config.homelab.vpnInterface}.allowedTCPPorts = mkIf (config.homelab.vpnInterface != null) (map (app: app.port) apps);
    };
  };
}
