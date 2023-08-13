{pkgs, ...}: {
  boot.plymouth = {
    enable = true;
    themePackages = [(pkgs.callPackage ../pkgs/catppuccin-plymouth.nix {})];
    theme = "catppuccin-mocha";
  };
  boot.initrd.systemd.enable = true;
}
