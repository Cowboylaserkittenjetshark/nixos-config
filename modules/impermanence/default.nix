# Assumes:
# - LUKS FDE
# - btrfs
#
{
  inputs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.impermanence;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];
  options = {
    impermanence = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable impermanence";
      };
      persistPath = mkOption {
        type = types.str;
        default = "/persist";
        description = mdDoc ''
          Path where persisted data is mounted on the booted system.
        '';
      };
      cryptDeviceName = mkOption {
        type = types.str;
        default = "crypt";
        description = mdDoc ''
          Mapped name of the opened LUKS device under /dev/mapper/
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    fileSystems.${cfg.persistPath}.neededForBoot = true;
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/etc/secureboot"
        # "/var/log"
        # "/var/lib/bluetooth"
        # "/var/lib/nixos"
        # "/var/lib/systemd/coredump"
      ];
      files = [
        "/etc/machine-id"
        "/etc/adjtime"
        "/etc/ssh/id_ed25519_builder"
        "/etc/ssh/id_ed25519_builder.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
    boot.initrd.systemd.emergencyAccess = false; # Set to true for debuging initrd
    boot.initrd.systemd.services.rollback = {
      description = "Reset subvolumes for impermanence";
      wantedBy = [
        "initrd.target"
      ];
      after = [
        # LUKS/TPM process
        "systemd-cryptsetup@${cfg.cryptDeviceName}.service"
      ];
      before = [
        "sysroot.mount"
      ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir /btrfs_tmp
        mount /dev/mapper/${cfg.cryptDeviceName} /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };
  };
}
