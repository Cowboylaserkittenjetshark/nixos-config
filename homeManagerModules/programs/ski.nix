{ inputs, pkgs, ... }:
{
  imports = [
    inputs.ski.homeModules.default
  ];
  home.packages = [ inputs.ski.packages.${pkgs.system}.default ];

  programs.ski = {
    enable = true;
    settings = {
      pairs = {
        yk.name = "yk_9767";
        t2a.name = "t2_5610_auth";
        t2s.name = "t2_5610_git";
      };
      roles = {
        auth.target = "id_ed25519_sk";
        sign.target = "signing-key";
      };
    };
  };
}
