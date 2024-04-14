{
  lib,
  config,
  ...
}: let
  machines = [
    {
      hostName = "tower";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      sshUser = "builder";
      sshKey = "/etc/ssh/id_ed25519_builder";

      maxJobs = 4;
      # Arbitrary measure of speed; Priority
      speedFactor = 2;
      supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    }
  ];
in {
  nix = {
    distributedBuilds = true;
    buildMachines = lib.filter (machine: machine.hostName != config.networking.hostName) machines;
    settings.trusted-users = [ "builder" ];
    settings.builders-use-substitutes = true;
  };

  users.users.builder = lib.mkIf (builtins.elem config.networking.hostName (map (machine: machine.hostName) machines)) {
    isNormalUser = true;
    createHome = true;
    homeMode = "500";
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF/4MwGjm7Q46gtQqjgnlKAN6fo4ORC/C1s4WG3NguV3 root@lap"];
  };
}
