{...}: 
let
  commonSubvolMountOptions = [
    "compress=zstd"
    "noatime"
  ];
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b478ba668";
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
                      mountpoint = "/home";
                      mountOptions = commonSubvolMountOptions;
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = commonSubvolMountOptions;
                    };
                    "/var" = {
                      mountpoint = "/var";
                      mountOptions = commonSubvolMountOptions;
                    };
                    "/persist" = {
                      mountpoint = "/persist";
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
