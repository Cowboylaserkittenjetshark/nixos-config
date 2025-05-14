{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.qbittorrent;
  inherit (lib)
    mkOption
    mkEnableOption
    types
    literalExpression
    mkIf
    ;
in
{
  options.services.qbittorrent = {
    enable = mkEnableOption (lib.mdDoc "qBittorrent headless");

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/qbittorrent";
      description = "The directory where qBittorrent stores its data files.";
    };

    user = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = "User account under which qBittorrent runs.";
    };

    group = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = "Group under which qBittorrent runs.";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "qBittorrent web UI port.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open services.qBittorrent.port to the outside network.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.qbittorrent-nox;
      defaultText = literalExpression "pkgs.qbittorrent-nox";
      description = "The qbittorrent package to use.";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.qbittorrent = {
      # based on the plex.nix service module and
      # https://github.com/qbittorrent/qBittorrent/blob/master/dist/unix/systemd/qbittorrent-nox%40.service.in
      # and https://github.com/pceiley/nix-config/blob/4738958966cd48dc45fd3ce59d7fb8a3facf2208/hosts/common/modules/qbittorrent.nix#L69-L110
      unitConfig = {
        Description = "qBittorrent-nox service";
        Documentation = [ "man:qbittorrent-nox(1)" ];
        Wants = [ "network-online.target" ];
        After = [
          "local-fs.target"
          "network-online.target"
          "nss-lookup.target"
        ];
      };

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        PrivateTmp = false;
        User = cfg.user;
        Group = cfg.group;
        TimeoutStopSec = 1800;

        # Run the pre-start script with full permissions (the "!" prefix) so it
        # can create the data directory if necessary.
        ExecStartPre =
          let
            preStartScript = pkgs.writeScript "qbittorrent-run-prestart" ''
              #!${pkgs.bash}/bin/bash

              # Create data directory if it doesn't exist
              if ! test -d "$QBT_PROFILE"; then
                echo "Creating initial qBittorrent data directory in: $QBT_PROFILE"
                install -d -m 0755 -o "${cfg.user}" -g "${cfg.group}" "$QBT_PROFILE"
              fi
            '';
          in
          "!${preStartScript}";

        ExecStart = "${cfg.package}/bin/qbittorrent-nox";
      };

      environment = {
        QBT_PROFILE = cfg.dataDir;
        QBT_WEBUI_PORT = toString cfg.port;
      };
    };

    users.users = mkIf (cfg.user == "qbittorrent") {
      qbittorrent = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "qbittorrent") {
      qbittorrent = {
      };
    };
  };
}
