{ lib, pkgs, config, ... }:
{
  imports = [
    ./chromium.nix
    ./cider.nix
    ./waveforms.nix
    ./code_composer_studio.nix
  ];
  config.programs = lib.mkIf config.desktopEnvironment.enable {
    gnupg.agent.enable = true;
    ssh = {
      enableAskPassword = true;
      askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
    };
  };
}
