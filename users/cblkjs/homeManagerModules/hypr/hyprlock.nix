{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.hyprlock.homeManagerModules.hyprlock
  ];

  programs.hyprlock = let
    accent = "green";
  in {
    enable = true;
    sources = [ "${inputs.catppuccin-hyprland}/themes/mocha.conf" ];

    general = {
      disable_loading_bar = true;
      hide_cursor = true;
      grace = 3;
    };
    
    backgrounds = [
      {
        monitor = "";
        path = "";
        blur_passes = 0;
        color = "$base";
      }
    ];

    input-fields = [
      {
        monitor = "";
        size = {
          width = 300;
          height = 60;
        };
        outline_thickness = 4;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "\$${accent}";
        inner_color = "$surface0";
        font_color = "$text";
        fade_on_empty = false;
        placeholder_text = ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##''$${accent}Alpha">$USER</span></span>'';
        hide_input = false;
        check_color = "\$${accent}";
        fail_color = "$red";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = "$yellow";
        position = {
          x = 0;
          y = -35;
        };
        halign = "center";
        valign = "center";
      }
    ];

    labels = [
      {
        monitor = "";
        text = ''cmd[update:30000] echo "$(date +"%R")"'';
        color = "$text";
        font_size = 90;
        font_family = "MesloLGS NF";
        position = {
          x = -30;
          y = 0;
        };
        halign = "right";
        valign = "top";
      }
      {
        monitor = "";
        text = ''cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"'';
        color = "$text";
        font_size = 25;
        font_family = "$font";
        position = {
          x = -30;
          y = -150;
        };
        halign = "right";
        valign = "top";
      }
    ];
    images = [
      {
        monitor = "";
        path = config.avatar;
        size = 100;
        border_color = "\$${accent}";
        position = {
          x = 0;
          y = 75;
        };
        halign = "center";
        valign = "center";
      }
    ];
  };
}
