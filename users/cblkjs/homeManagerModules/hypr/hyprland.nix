{
  config,
  osConfig,
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  wayland.windowManager.hyprland.extraConfig = ''
    ${builtins.readFile ((inputs.catppuccin-hyprland) + "/themes/mocha.conf")}
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
        scroll_factor = 0.25
      }
    }

    animations {
      bezier=overshot,0.7,0.6,0.1,1.1
      bezier=linear,0,0,1,1
      bezier=bounce,1,1.6,0.1,0.85

      animation=windows,1,5,overshot,popin 80%
      animation=fade,1,3,overshot
      animation=workspaces,1,6,overshot,slide
      animation=border,1,2,overshot
      animation=borderangle,1,40,default,loop
      animation=layers,1,5,overshot,slide
    }

    dwindle {
      pseudotile=1 # enable pseudotiling on dwindle
      preserve_split=true
    }

    misc {
      disable_hyprland_logo	= true
      enable_swallow = true
      swallow_regex = ^(foot)$
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
    bind=SUPERALT,L,exec,hyprlock --immediate
    bind=SUPER,V,togglefloating,
    bind=SUPER,P,pseudo,
    bind=SUPER,M,fullscreen,1
    bind=SUPER,F,fullscreen,2

    bind=SUPER,h,movefocus,l
    bind=SUPER,l,movefocus,r
    bind=SUPER,k,movefocus,u
    bind=SUPER,j,movefocus,d

    bind=SUPER, bracketleft, focusmonitor, l
    bind=SUPER, bracketright, focusmonitor, r
    bind=SUPER SHIFT, bracketleft, movecurrentworkspacetomonitor, l
    bind=SUPER SHIFT, bracketright, movecurrentworkspacetomonitor, r

    binde=,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
    binde=,XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
    bind=,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    layerrule = blur, notifications
    layerrule = ignorezero, notifications

    exec-once=swaybg -i ${osConfig.desktopAssets.wallpaper}
  '';
}
