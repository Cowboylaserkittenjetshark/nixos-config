{ inputs, ... }: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "MesloLGS NF:size=11";
      };
    } // inputs.catppuccin-foot.flavors.mocha;
  };
}
