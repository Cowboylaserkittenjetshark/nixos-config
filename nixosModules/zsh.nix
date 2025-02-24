{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting = {
      enable = true;
      patterns = {"rm -rf *" = "fg=black,bg=red";};
      styles = {"alias" = "fg=magenta";};
      highlighters = ["main" "brackets" "pattern"];
    };
  };
  environment.shells = with pkgs; [zsh];
  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = ["/share/zsh"];
}
