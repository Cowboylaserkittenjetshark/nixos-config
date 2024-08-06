{...}: {
  imports = [
    ./vpns.nix
    ./tailscale.nix
    ./sshd.nix
  ];
}
