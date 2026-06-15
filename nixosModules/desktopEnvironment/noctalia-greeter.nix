{ pkgs, inputs, config, ... }:  {
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  programs.noctalia-greeter = {
    enable = config.desktopEnvironment.enable;
    package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;

    greeter-args = "--session Niri --user cblkjs";
    settings.cursor = let cfg = config.stylix.cursor; in {
      theme = cfg.name;
      inherit (cfg) size package;
    };
  };
}
