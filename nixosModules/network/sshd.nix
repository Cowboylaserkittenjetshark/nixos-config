{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkForce mkOption types;
in {
  config = mkIf config.systemAttributes.roles.server {
    services.openssh = {
      enable = true;
      # require public key authentication for better security
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
      # make sure no ports are open by default
      openFirewall = mkForce false;
    };
    networking.firewall.interfaces = mkIf config.services.openssh.vpnAccess.enable {${config.services.openssh.vpnAccess.interface}.allowedTCPPorts = config.services.openssh.ports;};
  };
  options.services.openssh.vpnAccess = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the specified listen ports to the specified VPN interface";
    };
    interface = mkOption {
      type = types.str;
      default = null;
      description = "Name of the vpn interface";
    };
  };
}
