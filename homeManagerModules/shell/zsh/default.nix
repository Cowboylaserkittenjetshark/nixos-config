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
      syntaxHighlighting.enable = true;
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
          name = "zshelix";
          src = inputs.zshelix;
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
      '';
      initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        ${builtins.readFile ./p10k.zsh}
      '';
    };
  };

  # For p10k
  home.packages = [pkgs.meslo-lgs-nf];
}
