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
        color = "rgb(108, 112, 134)";
      }
    ];

    input_field = {
      monitor = "";
      size = {
        width = 300;
        height = 40;
      };
      outline_thickness = 3;

      outer_color = "rgb(151515)";
      inner_color = "rgb(200, 200, 200)";
      font_color = "rgb(10, 10, 10)";

      fade_on_empty = true;
      placeholder_text = "<i>Input Password...</i>";
      hide_input = false;

      position = {
        x = 0;
        y = -30;
      };

      halign = "center";
      valign = "center";
    };

    label = {
      monitor = "";
      text = "Hi there, $USER";
      color = "rgba(200, 200, 200, 1.0)";
      font_size = 25;
      font_family = "MesloLGS NF";
      position = {
        x = 0;
        y = 30;
      };
      halign = "center";
      valign = "center";
    };
  };
}
