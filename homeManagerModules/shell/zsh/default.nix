{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.zsh;
in {
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      completionInit = ''
        autoload -U compinit && compinit
        # Case insensitive completion
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        # Colorize completion list
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      '';
      autosuggestion.enable = true;
      # We enable this manually in initExtra
      syntaxHighlighting.enable = false;
      dotDir = ".config/zsh";
      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        ignoreAllDups = true;
        saveNoDups = true;
        findNoDups = true;
        ignoreSpace = true;
        expireDuplicatesFirst = true;
        append = true;
        share = true;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      plugins = [
        {
          name = "zsh-helix-mode";
          src = inputs.zsh-helix-mode;
        }
      ];
      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        export GPG_TTY=$TTY

        # Must be sourced before plugins
        if [[ $options[zle] = on ]]; then
          eval "$(${pkgs.fzf}/bin/fzf --zsh)"
        fi

        ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
          zhm_history_prev
          zhm_history_next
          zhm_prompt_accept
          zhm_accept
          zhm_accept_or_insert_newline
        )
        ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(
          zhm_move_right
        )
        ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(
          zhm_move_next_word_start
          zhm_move_next_word_end
        )
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

        # Manually enable syntax highlighting to get proper ordering with zhm compat hook
        source ${cfg.syntaxHighlighting.package}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS+=(${lib.concatStringsSep " " (map lib.escapeShellArg cfg.syntaxHighlighting.highlighters)})
        ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList
              (name: value: "ZSH_HIGHLIGHT_STYLES+=(${lib.escapeShellArg name} ${lib.escapeShellArg value})")
              cfg.syntaxHighlighting.styles
        )}
        ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList
              (name: value: "ZSH_HIGHLIGHT_PATTERNS+=(${lib.escapeShellArg name} ${lib.escapeShellArg value})")
              cfg.syntaxHighlighting.patterns
        )}
        
        # Fix highlighting conflict between zhm and syntax highlighting
        zhm-add-update-region-highlight-hook
      '';
    };
  };

  # For p10k
  home.packages = [pkgs.meslo-lgs-nf];
}
