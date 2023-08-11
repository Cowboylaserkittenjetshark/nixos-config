{ pkgs, ... }: {
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];
}
