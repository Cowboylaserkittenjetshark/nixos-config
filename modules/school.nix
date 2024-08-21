{pkgs, ...}: {
  environment.systemPackages = with pkgs; [firefox gedit filezilla libreoffice-qt6-fresh nwg-drawer];
}
