{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];
  age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
    pkgs.age-plugin-yubikey
  ];

  services.pcscd.enable = true;
}
