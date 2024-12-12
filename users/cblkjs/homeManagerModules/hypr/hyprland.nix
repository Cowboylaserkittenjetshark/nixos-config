{
  osConfig,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.systemAttributes.graphical {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      plugins = [
        pkgs.hyprlandPlugins.hyprscroller
      ];
    };

    wayland.windowManager.hyprland.extraConfig = ''
      monitor=,preferred,auto,auto

      general {
        layout = ${if osConfig.systemAttributes.roles.laptop then "scroller" else "dwindle"}
        gaps_in = 5
        gaps_out = 5
        gaps_workspaces = 50
        border_size = 1
        col.active_border = $pink $lavender
        col.inactive_border = $surface0
      }

      decoration {
        rounding = 16

        blur {
          enabled = true
          xray = true
          special = false
          size = 1
          passes = 4
          popups = true
          popups_ignorealpha = 0.6
        }
      }


      input {
        touchpad {
          disable_while_typing = false
          scroll_factor = 0.25
        }
      }

      animations {
        bezier = md3_decel, 0.05, 0.7, 0.1, 1
        bezier = md3_accel, 0.3, 0, 0.8, 0.15
        bezier = menu_decel, 0.1, 1, 0, 1
        bezier = menu_accel, 0.38, 0.04, 1, 0.07

        animation = windows, 1, 3, md3_decel, popin 60%
        animation = windowsIn, 1, 3, md3_decel, popin 60%
        animation = windowsOut, 1, 3, md3_accel, popin 60%
        animation = border, 1, 10, default
        animation = fade, 1, 3, md3_decel
        animation = layersIn, 1, 3, menu_decel, slide
        animation = layersOut, 1, 1.6, menu_accel
        animation = fadeLayersIn, 1, 2, menu_decel
        animation = fadeLayersOut, 1, 4.5, menu_accel
        animation = workspaces, 1, 7, menu_decel, slide
        animation = specialWorkspace, 1, 3, md3_decel, slidevert
      }

      dwindle {
        pseudotile=1 # enable pseudotiling on dwindle
        preserve_split=true
      }

      misc {
        disable_hyprland_logo	= true
        vrr = 1
        new_window_takes_over_fullscreen = 2
        initial_workspace_tracking = 2
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

      gestures {
          workspace_swipe = true
          workspace_swipe_distance = 700
          workspace_swipe_fingers = 3
          workspace_swipe_cancel_ratio = 0.2
          workspace_swipe_min_speed_to_force = 5
          workspace_swipe_direction_lock = true
          workspace_swipe_direction_lock_threshold = 10
          workspace_swipe_create_new = true
      }

      # Window Rules
      windowrulev2 = float,title:OpenSSH Authentication Passphrase request

      ## Browser Picture in Picture
      windowrulev2 = float, title:^([P|p]icture.*in.*[P|p]icture)$
      windowrulev2 = pin, title:^([P|p]icture.*in.*[P|p]icture)$
      windowrulev2 = move 69.5% 4%, title:^([P|p]icture.*in.*[P|p]icture)$

      ## File dialogs
      windowrulev2 = float, title:^((Save|Open) Files*)$
      windowrulev2 = pin, title:^((Save|Open) Files*)$
      windowrulev2 = size 75% 50%, title:^((Save|Open) Files*)$

      windowrulev2 = opacity 0.80,class:^(foot)$
      windowrulev2 = opacity 0.80,title:^(Bitwarden)$
      windowrulev2 = opacity 0.80,class:^(qt5ct)$
      windowrulev2 = opacity 0.80,class:^(qt6ct)$
      windowrulev2 = opacity 0.80,class:^(org.pulseaudio.pavucontrol)$
      windowrulev2 = opacity 0.80,class:blueman-manager
      windowrulev2 = opacity 0.80,class:^(org.freedesktop.impl.portal.desktop.gtk)$
      windowrulev2 = opacity 0.80,class:^(org.freedesktop.impl.portal.desktop.hyprland)$
      windowrulev2 = opacity 0.70,class:^([Ss]team)$
      windowrulev2 = opacity 0.70,class:^(steamwebhelper)$
      windowrulev2 = opacity 0.70,class:^(Spotify)$
      windowrulev2 = opacity 0.70,initialTitle:^(Spotify Free)$
      windowrulev2 = opacity 0.70,initialTitle:^(Spotify Premium)$

      windowrulev2 = float,class:^(foot)$,title:^(btop)$
      windowrulev2 = float,class:^(foot)$,title:^(htop)$
      windowrulev2 = float,class:^(qt5ct)$
      windowrulev2 = float,class:^(qt6ct)$
      windowrulev2 = float,class:^(org.pulseaudio.pavucontrol)$
      windowrulev2 = float,class:blueman-manager
      windowrulev2 = float,class:^(Signal)$ # Signal-Gtk

      layerrule = blur,notifications
      layerrule = ignorezero,notifications

      exec-once=${lib.getExe pkgs.swaybg} -m fill -i ${osConfig.desktopAssets.wallpaper}
    '';
  };
}
