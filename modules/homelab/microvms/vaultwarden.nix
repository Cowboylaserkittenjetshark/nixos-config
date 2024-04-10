{inputs, ...}: {
  imports = [];

  options = {};

  config = {
    microvm.vms.vaultwarden = {
      config = {
        microvm = {
          shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }
          ];
          interfaces = [
            {
              type = "tap";
              id = "vm-vaultwarden";
              mac = "02:0f:30:47:e8:9e";
            }
          ];
        };
      };
    };
  };
}
