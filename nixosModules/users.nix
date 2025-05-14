{ pkgs, ... }:
{
  users.users.cblkjs = {
    hashedPasswordFile = "/persist/secrets/cblkjs-passwd";
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "plugdev"
    ];
  };
}
