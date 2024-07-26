{inputs, ...}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    pointerCursor.enable = true;
    flavor = "mocha";
    accent = "green";
  };
}
