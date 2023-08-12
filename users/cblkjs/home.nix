{ config, pkgs, inputs, ... }:
rec {
  imports = [
    ./modules/foot.nix
    ./modules/zsh.nix
    ./modules/hyprland.nix
    ./modules/tofi.nix
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "cblkjs";
    homeDirectory = "/home/cblkjs";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    tofi
    eww-wayland
    swaylock-effects
    swayidle
    swaybg
    meslo-lgs-nf # For p10k
  ];

  fonts.fontconfig.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
