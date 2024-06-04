{config, ...}: let
  vw_data_dir = config.services.vaultwarden.config.DATA_FOLDER;
  vw_backup_dir = "/var/backup/vaultwarden";
in {
  services.restic.backups.homelab = {
    initialize = true;

    environmentFile = config.age.secrets.restic-env.path;
    repositoryFile = config.age.secrets.restic-repo.path;
    passwordFile = config.age.secrets.restic-password.path;

    paths = [
      "${vw_data_dir}/config.json"
      "${vw_data_dir}/attachments"
      "${vw_data_dir}/sends"
      "${vw_data_dir}/rsa_key.der"
      "${vw_data_dir}/rsa_key.pem"
      "${vw_data_dir}/rsa_key.pub.der"
      "${vw_backup_dir}/db.sqlite3"
    ];

    backupPrepareCommand = pkgs.writeShellScript "backup-prepare" ''
      ${pkgs.systemd}/bin/systemd-tmpfiles --create
      if [ ! -d "${vw_backup_dir}" ]; then
        echo "Backup folder '${vw_backup_dir}' does not exist" >&2
        exit 1
      fi

      if [[ ! -f "${vw_data_dir}"/db.sqlite3 ]]; then
        echo "Could not find SQLite database file '${vw_data_dir}/db.sqlite3'" >&2
        exit 1
      fi

      ${pkgs.sqlite}/bin/sqlite3 "${vw_data_dir}"/db.sqlite3 ".backup '${vw_backup_dir}/db.sqlite3'"
    '';

    backupCleanupCommand = pkgs.writeShellScript "backup-cleanup" ''
      ${pkgs.systemd}/bin/systemd-tmpfiles --remove
    '';
  };

  systemd.tmpfiles.settings."10-vaultwarden".${vw_backup_dir}.D = {
    user = "vaultwarden";
    group = "vaultwarden";
    mode = "0770";
  };

  age.secrets = {
    restic-env.file = ../../secrets/restic/env.age;
    restic-repo.file = ../../secrets/restic/repo.age;
    restic-password.file = ../../secrets/restic/password.age;
  };
}
