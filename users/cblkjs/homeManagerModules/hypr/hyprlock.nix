{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprlock.homeManagerModules.hyprlock
  ];

  programs.hyprlock = {
    enable = true;

    backgrounds = [
      {
        path = "";
        color = "rgb(30, 30, 46)";
      }
    ];

    input-fields = [
      {
        monitor = "";
        size = {
          width = 300;
          height = 40;
        };
        outline_thickness = 3;

        outer_color = "rgb(69, 71, 90)";
        inner_color = "rgb(49, 50, 68)";
        font_color = "rgb(205, 214, 244)";

        fade_on_empty = true;
        placeholder_text = "<i>Input Password...</i>";
        hide_input = false;

        position = {
          x = 0;
          y = -30;
        };

        halign = "center";
        valign = "center";
      }
    ];

    labels = [
      {
        monitor = "";
        text = "$TIME";
        color = "rgba(200, 200, 200, 1.0)";
        font_size = 50;
        font_family = "MesloLGS NF";
        position = {
          x = 0;
          y = 30;
        };
        halign = "center";
        valign = "center";
      }
    ];
  };
}
