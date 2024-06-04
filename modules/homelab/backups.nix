{
  config,
  pkgs,
  ...
}: let
  vw_data_dir = config.services.vaultwarden.config.DATA_FOLDER;
  nc_home_dir = config.services.nextcloud.home;
  db_backup_dir = "/var/backup";
in {
  services.restic.backups.homelab = {
    initialize = true;

    environmentFile = config.age.secrets.restic-env.path;
    repositoryFile = config.age.secrets.restic-repo.path;
    passwordFile = config.age.secrets.restic-password.path;

    paths = [
      # Vaultwarden
      "${vw_data_dir}/config.json"
      "${vw_data_dir}/attachments"
      "${vw_data_dir}/sends"
      "${vw_data_dir}/rsa_key.der"
      "${vw_data_dir}/rsa_key.pem"
      "${vw_data_dir}/rsa_key.pub.der"
      # Nextcloud
      "${nc_home_dir}"
      # Backup DBs
      "${db_backup_dir}"
    ];

    backupPrepareCommand = ''
      # Backup DBs
      ${pkgs.systemd}/bin/systemd-tmpfiles --create
      if [ ! -d "${db_backup_dir}" ]; then
        echo "Backup folder '${db_backup_dir}' does not exist" >&2
        exit 1
      fi

      if [[ ! -f "${vw_data_dir}"/db.sqlite3 ]]; then
        echo "Could not find SQLite database file '${vw_data_dir}/db.sqlite3'" >&2
        exit 1
      fi

      mkdir --parents ${db_backup_dir}/vaultwarden
      ${pkgs.sqlite}/bin/sqlite3 "${vw_data_dir}"/db.sqlite3 ".backup '${db_backup_dir}/vaultwarden/db.sqlite3'"

      # Nextcloud
      if [[ ! -f "${nc_home_dir}"/data/nextcloud.db ]]; then
        echo "Could not find SQLite database file '${nc_home_dir}/data/nextcloud.db'" >&2
        exit 1
      fi

      ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --on
      mkdir --parents ${db_backup_dir}/nextcloud
      ${pkgs.sqlite}/bin/sqlite3 "${nc_home_dir}"/data/nextcloud.db ".backup '${db_backup_dir}/nextcloud/nextcloud.db'"
    '';

    backupCleanupCommand = ''
      ${pkgs.systemd}/bin/systemd-tmpfiles --remove

      # Nextcloud
      ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --off
    '';
  };

  systemd.tmpfiles.settings."10-backups".${db_backup_dir}.D = {
    user = "root";
    group = "root";
    mode = "0770";
  };

  age.secrets = {
    restic-env.file = ../../secrets/restic/env.age;
    restic-repo.file = ../../secrets/restic/repo.age;
    restic-password.file = ../../secrets/restic/password.age;
  };
}
