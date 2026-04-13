{pkgs, ...}: {
  imports = [
    ./chromium.nix
    ./cider.nix
    ./gnupg.nix
    ./waveforms.nix
    ./code_composer_studio.nix
  ];
  programs.ssh = {
    enableAskPassword = true;
    askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
  };
}
