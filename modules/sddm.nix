{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ../pkgs/catppuccin-sddm.nix {})
  ];
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "catppuccin-mocha";
    };
  };
}
