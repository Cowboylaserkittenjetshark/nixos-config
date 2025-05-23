{pkgs, ...}: {
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$fill$nix_shell$line_break$python$character";

      directory.style = "bold lavender";
      
      character = {
        success_symbol = "[❯](mauve)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      
      git_branch = {
        format = "[$branch]($style)";
        style = "bold mauve";
      };

      git_status = {
        format = "[$ahead_behind$staged$modified$renamed$deleted$untracked$conflicted$stashed]($style) ";
        style = "sky";
        ahead = " [$count⇡](green)";
        behind = " [$count⇣](green)";
        diverged = " [⇕](peach)⇡$ahead_count⇣$behind_count";
        staged = " [$count+](yellow)";
        modified = " [$count!](yellow)";
        renamed = " [»$count](yellow)";
        deleted = " [$count󰧧](red)";
        untracked = " [$count?](blue)";
        conflicted = "​[󰞇$count](red)";
        stashed = " $count≡";
      };

      git_state = {
        format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "yellow";
      };

      nix_shell = {
        format = "[$symbol $state]($style) ";
        symbol = "";
      };

      fill.symbol = " ";
    };
  };

  home.packages = [ pkgs.meslo-lgs-nf ];
}
