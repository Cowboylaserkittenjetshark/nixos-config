{
  config,
  pkgs,
  inputs,
  ...
}: rec {
  imports = [
    ./homeManagerModules/foot.nix
    ./homeManagerModules/shell/zsh
    ./homeManagerModules/hypr
    ./homeManagerModules/tofi.nix
    ./homeManagerModules/syncthing.nix
    ./homeManagerModules/helix.nix
    ../common/homeManagerModules/direnv.nix
    ./homeManagerModules/git.nix
    ./homeManagerModules/gtk.nix
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

  services.mako.enable = true;
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  programs.nnn.enable = true;

  home.packages = with pkgs; [
    htop
    # eww-wayland
    swayidle
    swaybg
    meslo-lgs-nf # For p10k
    obsidian
    bitwarden
    chromium
    thunderbird
    eza
    bat
    okular
    pandoc
    p7zip
    ncspot
  ];

  fonts.fontconfig.enable = true;
}
