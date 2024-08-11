{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history = {
      size = 10000;
      expireDuplicatesFirst = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      export GPG_TTY=$TTY
    '';
    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      ${builtins.readFile ./p10k.zsh}
      ${
        lib.optionalString config.programs.nnn.enable ''
          n ()
          {
            # Block nesting of nnn in subshells
            [ "''${NNNLVL:-0}" -eq 0 ] || {
              echo "nnn is already running"
              return
            }

            # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
            # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
            # see. To cd on quit only on ^G, remove the "export" and make sure not to
            # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
            #      NNN_TMPFILE="''${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
            export NNN_TMPFILE="''${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

            # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
            # stty start undef
            # stty stop undef
            # stty lwrap undef
            # stty lnext undef

            # The command builtin allows one to alias nnn to n, if desired, without
            # making an infinitely recursive alias
            command nnn "$@"

            [ ! -f "$NNN_TMPFILE" ] || {
                . "$NNN_TMPFILE"
                rm -f "$NNN_TMPFILE" > /dev/null
            }
          }
        ''
      }
      # https://github.com/jeffreytse/zsh-vi-mode
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
  };

  # For p10k
  home.packages = [pkgs.meslo-lgs-nf];
}
