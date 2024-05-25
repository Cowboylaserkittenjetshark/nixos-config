{inputs, ...}: 
let
  commonSubvolMountOptions = [
    "compress=zstd"
    "noatime"
  ];
in
{
  imports = [inputs.disko.nixosModules.disko];
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1"; # Replace with UUID
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults"];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = ["--force"];
                  subvolumes = {
                    "/root" =  {
                      mountpoint = "/";
                      mountOptions = commonSubvolMountOptions;
                    };
                    "/home" = {
                      mountPoint = "/home";
                      mountOptions = commonSubvolMountOptions;
                    };
                    "/nix" = {
                      mountPoint = "/nix";
                      mountOptions = commonSubvolMountOptions;
                    };
                    "/var" = {
                      mountPoint = "/var";
                      mountOptions = commonSubvolMountOptions;
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "48G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
