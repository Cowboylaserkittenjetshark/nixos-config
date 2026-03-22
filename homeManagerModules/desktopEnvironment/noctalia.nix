{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
programs.noctalia-shell = {
      enable = true;
      settings = {
        audio = {
          prefferedPlayer = "cider";
          visualizerType = "mirrored";
        };
        desktopWidgets.enabled = false;
        hooks.enabled = false;
        idle = {
          enabled = true;
          fadeDuration = 5;
          lockTimeout = 185;
          screenOffTimeout = 180;
        };
        nightLight = {
          enabled = true;
          autoSchedule = false;
          manualSunrise = "6:00";
          manualSunset = "23:00";
        };
        sessionMenu = {
          largeButtonsStyle = true;
          largeButtonsLayout = "grid";
        };
        appLauncher = {
          density = "comfortable";
          position = "follow_bar";
        };
        bar = {
          position = "top";
          density = "mini";
          showCapsule = false;
          showOutline = false;
          floating = false;
          outerCorners = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
                enableColorization = true;
                colorizeSystemIcon = "primary";
              }
              {
                id = "Workspace";
                showApplications = true;
                labelMode = "none";
                showBadge = false;
              }
            ];
            center = [
              {
                id = "MediaMini";
                hideMode = "hidden";
                maxWidth = 145;
                scrollingMode = "always";
                showAlbumArt = true;
                showVisualizer = true;
                useFixedWidth = false;
                visualizerType = "mirrored";
              }
            ];
            right = [
              { id = "Volume"; }
              { id = "Bluetooth"; }
              {
                id = "Battery";
                displayMode = "graphic";
                hideIfIdle = true;
                hideIfNotDetected = true;
                showNoctaliaPerformance = true;
                showPowerProfiles = true;
              }
              {
                id = "Clock";
                formatHorizontal = "h:mm AP";
                formatVertical = "h:mm AP";
              }
            ];
          };
        };
        general = {
          avatarImage = "${config.avatar}";
          compactLockScreen = true;
          showChangelogOnStartup = true;
          telemetryEnabled = false;
          lockScreenAnimations = true;
          lockScreenBlur = 0.75;
          lockScreenTint = 0.25;
        };
        ui.tooltipsEnabled = true;
        location = {
          analogClockInCalendar = true;
          weatherEnabled = false;
          use12hourFormat = true;
        };
        wallpaper.enabled = true;
        appLauncher = {
          enableClipboardHistory = true;
          terminalCommand = "foot";
        };
        notifications = {
          enabled = true;
          clearDismissed = false;
        };
        controlCenter = {
          shortcuts = {
            left = [
              { id = "Bluetooth"; }
              { id = "ScreenRecorder"; }
            ];
            right = [
              { id = "Notifications"; }
              { id = "PowerProfile"; }
              { id = "KeepAwake"; }
              { id = "NightLight"; }
            ];
          };
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
        dock.enabled = false;
        network.wifiEnabled = false;
        osd.location = "right";
      };
    };
}
