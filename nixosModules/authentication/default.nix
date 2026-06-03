{ config, ... }: {
  imports = [
    ./fprint.nix
    ./pam_u2f.nix
  ];
  
  security.polkit.enable = config.systemAttributes.graphical;
}
