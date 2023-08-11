{ config, pkgs, inputs, ... }:
rec {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "cblkjs";
    homeDirectory = "/home/cblkjs";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    tofi
    eww-wayland
    swaylock-effects
    swayidle
    swaybg
    meslo-lgs-nf # For p10k
  ];

  fonts.fontconfig.enable = true;

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "MesloLGS NF:size=11";
      };
    } // inputs.catppuccin-foot.flavors.mocha;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  wayland.windowManager.hyprland.extraConfig = ''
    ${ builtins.readFile ((inputs.catppuccin-hyprland) + "/themes/mocha.conf") }
    monitor=,preferred,auto,auto
    
    general {
      gaps_in = 5
      gaps_out = 5
      border_size = 2
      col.active_border = $pink $lavender
      col.inactive_border = $surface0
    }

    decoration {
      rounding = 7
      
      blur {
        enabled = true
        size = 3
        passes = 1
      }
    }

    input {
      touchpad {
        disable_while_typing = false
      }
    }

    animations { 
      bezier=overshot,0.7,0.6,0.1,1.1
      bezier=linear,0,0,1,1
      bezier=bounce,1,1.6,0.1,0.85
      
      animation=windows,1,5,bounce,popin
      animation=fade,1,3,bounce
      animation=workspaces,1,6,overshot,slide
      animation=border,1,2,linear
      animation=borderangle,1,40,linear,loop
    }
    
    dwindle {
      pseudotile=1 # enable pseudotiling on dwindle
      preserve_split=true
    }

    $mod = SUPER

    # workspaces
    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $mod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
        ''
      )
      10)}
      # Mouse binds
      bindm=SUPER,mouse:272,movewindow
      bindm=SUPER,mouse:273,resizewindow
      bind=SUPER,mouse_up,workspace,e-1
      bind=SUPER,mouse_down,workspace,e+1
      # Exec binds
      bindr=SUPER,RETURN,exec,foot
      bind=SUPER,D,exec,tofi-drun | xargs hyprctl dispatch exec --
      
      bind=SUPER,W,killactive,
      bind=SUPERALT,M,exit,
      bind=SUPERALT,R,exec,hyprctl reload
      bind=SUPER,V,togglefloating,
      bind=SUPER,P,pseudo,
      bind=SUPER,M,fullscreen,1
      bind=SUPER,F,fullscreen,2

      bind=SUPER,left,movefocus,l
      bind=SUPER,right,movefocus,r
      bind=SUPER,up,movefocus,u
      bind=SUPER,down,movefocus,d

      exec = eww open bar
      exec-once=swayidle -w timeout 90 'swaylock' timeout 300 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock --fade-in 0 --grace 0'
      exec-once=swaybg -i ${ home.homeDirectory }/.config/laptopWP
  '';

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
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
    initExtra = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}
