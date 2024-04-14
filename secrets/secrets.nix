let
  # User pub keys
  cblkjs = "age1yubikey1q0ephltfc22mllkg3esxuejymk39yg3asp8e57adm77zsr9cqk3cv60clmu";
  users = [cblkjs];

  # System pub keys
  tower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINv/CXWoX9CAUMQVvAP2h6zXg+afjXcIQfQoSeb2YShU";
  systems = [tower];
in {
  "cloudflare-tunnel-api-token.age".publicKeys = [cblkjs tower];
}
