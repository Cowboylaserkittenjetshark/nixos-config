{lib, pkgs, osConfig, ...}: {
  xdg.configFile."niri/config.kdl".text = ''
    prefer-no-csd

    output "eDP-1" {
      scale 2.0
    }
    
    input {
      focus-follows-mouse
        touchpad {
          tap
          natural-scroll
          accel-speed 0.25
        }
    }

    binds {
      // Misc
      Mod+W       { close-window; }
      Mod+Shift+Q { quit; }
      Mod+Shift+L { spawn "hyprlock" "--immediate"; }

      // Spawns
      Mod+Return { spawn "foot"; }
      Mod+D      { spawn "${ pkgs.writeShellScript "launcher.sh" "tofi-drun | xargs niri msg action spawn --"}"; }

      // Media keys
      XF86AudioRaiseVolume allow-when-locked=true repeat=false { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
      XF86AudioLowerVolume allow-when-locked=true repeat=false { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
      XF86AudioMute        allow-when-locked=true repeat=false { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
      XF86AudioMicMute     allow-when-locked=true repeat=false { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

      // Focus column/window
      Mod+Left  { focus-column-left; }
      Mod+Down  { focus-window-down; }
      Mod+Up    { focus-window-up; }
      Mod+Right { focus-column-right; }

      Mod+H     { focus-column-left; }
      Mod+J     { focus-window-or-workspace-down; }
      Mod+K     { focus-window-or-workspace-up; }
      Mod+L     { focus-column-right; }

      Mod+Home { focus-column-first; }
      Mod+End  { focus-column-last; }

      Mod+M { maximize-column; }
      Mod+F { fullscreen-window; }
      Mod+C { center-column; }


      // Move column/window
      Mod+Ctrl+Left  { move-column-left; }
      Mod+Ctrl+Down  { move-window-down; }
      Mod+Ctrl+Up    { move-window-up; }
      Mod+Ctrl+Right { move-column-right; }

      Mod+Ctrl+H     { move-column-left; }
      Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
      Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }
      Mod+Ctrl+L     { move-column-right; }

      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End  { move-column-to-last; }

      // Focus monitor
      Mod+Shift+Left  { focus-monitor-left; }
      Mod+Shift+Down  { focus-monitor-down; }
      Mod+Shift+Up    { focus-monitor-up; }
      Mod+Shift+Right { focus-monitor-right; }
      Mod+Shift+H     { focus-monitor-left; }
      Mod+Shift+J     { focus-monitor-down; }
      Mod+Shift+K     { focus-monitor-up; }
      Mod+Shift+L     { focus-monitor-right; }

      // Move to monitor
      Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }
    }

    // Applied to all windows
    window-rule {
      geometry-corner-radius 16
      clip-to-geometry true
    }

    // Open maximized
    window-rule {
      open-maximized true
      match app-id="chromium-browser"
    }

    // Apply transparency
    window-rule {
      opacity 0.95
      match app-id="foot"
    }

    layout {
      focus-ring {
        off
      }
      border {
        width 2
        active-gradient from="#b4befe" to="#a6e3a1" angle=45 relative-to="workspace-view"
        inactive-gradient from="#585b70" to="#7f849c" angle=45 relative-to="workspace-view"
      }

      gaps 5

      struts {
        left 16
        right 16
      }
    }

    hotkey-overlay {
        skip-at-startup
    }

    spawn-at-startup "${lib.getExe pkgs.swaybg}" "-m" "fill" "-i" "${osConfig.desktopAssets.wallpaper}"
  '';
}
