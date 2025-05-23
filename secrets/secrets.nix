let
  # User pub keys
  cblkjs = "age1yubikey1q0ephltfc22mllkg3esxuejymk39yg3asp8e57adm77zsr9cqk3cv60clmu";

  # System pub keys
  tower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINv/CXWoX9CAUMQVvAP2h6zXg+afjXcIQfQoSeb2YShU";
  lap = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3s7N+BxkhCjisPLy7G0TsOvNEl9FwuiMIjj0ECPf2H";
  No2TypeL = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEdFDjufx08HAlP1r3F8mBuO2wD96h5QVpeBGNwTOol8";
  No3TypeL = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/MRqDZRbMdLAnrCZohyQINsby07ipPgZnxOQW4Vth9";
  No2TypeT = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/sqijQePv3VqxJI5wepjd7PELimM6NE9QtFx/oebV/";
  systems = [
    tower
    lap
    No2TypeL
    No2TypeT
    No3TypeL
  ];
  homelab = [
    cblkjs
    tower
  ];
in
{
  # Homelab module
  "caddy-cloudflare-dns.age".publicKeys = homelab;
  "vaultwarden-env.age".publicKeys = homelab;
  "nextcloud-admin-pass.age".publicKeys = homelab;
  "restic/env.age".publicKeys = homelab;
  "restic/repo.age".publicKeys = homelab;
  "restic/password.age".publicKeys = homelab;
  "adguard-home-webui-password.age".publicKeys = homelab;

  # VPN configs
  "Windscribe-Atlanta-Mountain-conf.age".publicKeys = [ cblkjs ] ++ systems;
  "Windscribe-Atlanta-Mountain-auth.age".publicKeys = [ cblkjs ] ++ systems;
  "Windscribe-WashingtonDC-Precedent-conf.age".publicKeys = [ cblkjs ] ++ systems;
  "Windscribe-WashingtonDC-Precedent-auth.age".publicKeys = [ cblkjs ] ++ systems;
  "Windscribe-Dallas-Ranch-conf.age".publicKeys = [ cblkjs ] ++ systems;
  "Windscribe-Dallas-Ranch-auth.age".publicKeys = [ cblkjs ] ++ systems;
  "vpns/windscribe/wireguard/keypair_1/pk.age".publicKeys = [ cblkjs ] ++ systems;
  "vpns/windscribe/wireguard/keypair_1/peer_psk.age".publicKeys = [ cblkjs ] ++ systems;
  "vpns/windscribe/wireguard/keypair_2/pk.age".publicKeys = [ cblkjs ] ++ systems;
  "vpns/windscribe/wireguard/keypair_2/peer_psk.age".publicKeys = [ cblkjs ] ++ systems;

  # Wallpapers
  "Forest-Kingdom-Dithered-Mocha.age".publicKeys = [ cblkjs ] ++ systems;
  "Amusement-Park2-Dithered-Mocha.age".publicKeys = [ cblkjs ] ++ systems;
  "Forest-Kingdom-Desktop-Catppuccin-Mocha.age".publicKeys = [ cblkjs ] ++ systems;
}
