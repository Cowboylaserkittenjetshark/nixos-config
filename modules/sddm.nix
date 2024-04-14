{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ../pkgs/catppuccin-sddm.nix {})
  ];
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
  };
}
