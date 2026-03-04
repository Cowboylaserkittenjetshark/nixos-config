{pkgs, inputs, ...}: {
  environment.systemPackages = [ inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.Ev357.helium ];
}
