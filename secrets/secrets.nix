let
  # User pub keys
  cblkjs = "age1yubikey1q0ephltfc22mllkg3esxuejymk39yg3asp8e57adm77zsr9cqk3cv60clmu";
  users = [cblkjs];

  # System pub keys
  tower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINv/CXWoX9CAUMQVvAP2h6zXg+afjXcIQfQoSeb2YShU";
  lap = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3s7N+BxkhCjisPLy7G0TsOvNEl9FwuiMIjj0ECPf2H";
  No2TypeL = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEdFDjufx08HAlP1r3F8mBuO2wD96h5QVpeBGNwTOol8";
  systems = [tower lap No2TypeL];
  homelab = [cblkjs tower];
in {
  # Homelab module
  "caddy-cloudflare-dns.age".publicKeys = homelab;
  "vaultwarden-env.age".publicKeys = homelab;
  "nextcloud-admin-pass.age".publicKeys = homelab;
  "restic/env.age".publicKeys = homelab;
  "restic/repo.age".publicKeys = homelab;
  "restic/password.age".publicKeys = homelab;

  # VPN configs
  "Windscribe-Atlanta-Mountain-conf.age".publicKeys = [cblkjs] ++ systems;
  "Windscribe-Atlanta-Mountain-auth.age".publicKeys = [cblkjs] ++ systems;
  "Windscribe-WashingtonDC-Precedent-conf.age".publicKeys = [cblkjs] ++ systems;
  "Windscribe-WashingtonDC-Precedent-auth.age".publicKeys = [cblkjs] ++ systems;
}
