{lib, ...}: {
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
}
