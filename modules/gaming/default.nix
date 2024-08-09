{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  ngMods = inputs.nix-gaming.nixosModules;
  cfg = config.gaming;

  gamescopeArgs = [
    "--rt"
    "--expose-wayland"
  ];
in {
  imports = [
    ngMods.pipewireLowLatency
    ngMods.platformOptimizations
  ];

  options.gaming = {
    enable = lib.mkEnableOption "programs and optimizations for gaming.";
  };

  config = mkIf cfg.enable {
    services.pipewire.lowLatency.enable = true;
    programs = {
      steam = {
        enable = true;
        gamescopeSession = {
          enable = true;
          args = gamescopeArgs;
        };
        platformOptimizations.enable = true;
      };
      gamemode = {
        enable = true;
        settings = {
          general.renice = 15;
          custom = let
            notify = "${lib.getExe' pkgs.libnotify} -a 'Gamemode'";
          in {
            start = "${notify} Gamemode activated";
            end = "${notify} Gamemode deactivated";
          };
        };
      };
      gamescope = {
        enable = true;
        args = gamescopeArgs;
        capSysNice = true;
      };
    };
    hardware.graphics.enable32Bit = true; # Enables support for 32bit libs that steam uses
  };
}
