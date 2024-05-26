{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font = "Noto Sans";
      fontSize = "9";
      background = "${config.desktopAssets.wallpaper}";
      loginBackground = true;
    })
    (pkgs.where-is-my-sddm-theme.override {
      themeConfig.General = {
      background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      backgroundMode = "none";
      };
    })
  ];
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [qt6.qt5compat qt6.qtsvg];
  };
}
