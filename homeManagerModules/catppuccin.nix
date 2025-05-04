{inputs, ...}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    cursors.enable = true;
    flavor = "mocha";
    accent = "green";
    hyprlock.useDefaultConfig = false;
  };
}
