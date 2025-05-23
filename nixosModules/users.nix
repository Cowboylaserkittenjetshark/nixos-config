{ pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.fish;
    users.cblkjs = {
      hashedPasswordFile = "/persist/secrets/cblkjs-passwd";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "plugdev"
      ];
    };    
  };
}
