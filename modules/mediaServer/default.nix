{pkgs, lib, ...}:
{
  imports = [
    ./qbittorrent.nix
  ];
  services = {
    prowlarr.enable = true;
    sonarr.enable = true;
    radarr.enable = false;
    bazarr.enable = false;
    lidarr.enable = false;
    flaresolverr.enable = true;
    qbittorrent.enable = true;
  };
  users.groups.media.members = [
    "prowlarr"
    "sonarr"
    # "radarr"
    # "bazarr"
    # "lidarr"
    "qbittorrent"
  ];

  system.activationScripts.initMediaServer = lib.stringAfter [ "var" ] ''
    # Create data directory if it doesn't exist
    install -d -m 0775 -g media \
      /var/lib/mediaserver \
      /var/lib/mediaserver/media \
      /var/lib/mediaserver/media/tv \
      /var/lib/mediaserver/media/movies \
      /var/lib/mediaserver/usenet \
      /var/lib/mediaserver/torrents
  '';
}
