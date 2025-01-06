{inputs, ...}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    cursors.enable = true;
    flavor = "mocha";
    accent = "green";
  };
}
