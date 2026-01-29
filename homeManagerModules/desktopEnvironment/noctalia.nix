{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];
programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          position = "bottom";
          density = "compact";
          showCapsule = false;
          floating = true;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "TaskbarGrouped";
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
              {
                id = "Battery";
                displayMode = "alwaysShow";
                warningThreshold = 25;
              }
              {
                id = "Bluetooth";
              }
              {
                id = "Clock";
                customFont = "";
                formatHorizontal = "h:mm AP";
                formatVertical = "h:mm AP";
                usePrimaryColor = true;
              }
            ];
          };
        };
        general = {
          avatarImage = "${config.avatar}";
          compactLockScreen = true;
          showChangelogOnStartup = true;
          telemetryEnabled = false;
        };
        ui.tooltipsEnabled = true;
        location = {
          weatherEnabled = false;
          use12hourFormat = true;
        };
        wallpaper.enabled = false;
        appLauncher = {
          enableClipboardHistory = true;
          terminalCommand = "foot";
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
