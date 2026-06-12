{
  config,
  osConfig,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  config = lib.mkIf osConfig.desktopEnvironment.enable {
    home.packages = [ pkgs.evtest ];
    programs.noctalia = {
      enable = true;
      settings = {
        bar.widgets = {
          background_opacity = 0.9;
          start = [ "workspaces" ];
          center = [ "clock" "cat" ];
          end = [ "media" "tray" "notifications" "bluetooth" "battery" "control-center" ];
          margin_edge = 4;
          margin_ends = 4;
        };
        control_center.shortcuts = [
          { type = "caffeine"; }
          { type = "nightlight"; }
          { type = "nightlight"; }
          { type = "power_profile"; }
        ];
        desktop_widgets.enabled = false;
        lockscreen_widgets.enabled = false;
        lockscreen.blurred_desktop = true;
        shell = {
          app_icon_colorize = true;
          avatar_path = config.avatar;
          font_family = "Sarasa Gothic J";
          niri_overview_type_to_launch_enabled = true;
          password_style = "random";
          panel = {
            clipboard_placement = "attached";
            launcher_categories = false;
            launcher_placement = "attached";
            launcher_session_search = true;
            open_near_click_clipboard = true;
            open_near_click_control_center = true;
            open_near_click_launcher = true;
            open_near_click_session = true;
            open_near_click_wallpaper = true;
            transparency_mode = "glass";
          };
        };
        theme = {
          source = "community";
          community_palette = "Everforest";
          templates = {
            enable_builtin_templates = false;
            enable_community_templates = false;
          };
        };
        wallpaper.default.path = osConfig.stylix.image;
        weather.enabled = false;
        widget = {
          cat = {
            audio_spectrum = true;
            input_device = "/dev/input/event1";
            tappy_mode = true;
            type = "noctalia/bongocat:cat";
          };
          control-center.glyph = "christmas-tree";
          media = {
            hide_when_no_media = true;
            title_scroll = "always";
          };
          notifications.hide_when_no_unread = true;
          tray.drawer = true;
        };
        idle = {
          behavior_order = [ "lock" "screen-off" "lock-and-suspend" ];
          behavior = {
            lock = {
              action = "lock";
              enabled = true;
              timeout = 600;
            };
            lock-and-suspend = {
              action = "lock_and_suspend";
              enabled = true;
              timeout = 900;
            };
            screen-off = {
              action = "screen_off";
              enabled = true;
              timeout = 660;
            };
          };
        };
        nightlight.enabled = true;
        plugins.enabled = [ "noctalia/bongocat" ];
      };
    };
  };
}
