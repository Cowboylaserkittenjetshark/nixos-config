{lib, config, ...}: {
  config = lib.mkIf config.systemAttributes.graphical {
    programs.steam = {
      enable = true;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    hardware.graphics.enable32Bit = true; # Enables support for 32bit libs that steam uses
  };
}
