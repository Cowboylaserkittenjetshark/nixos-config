{
  config,
  lib,
  ...
}: let
  devices =
    (lib.filterAttrs (device: attrs: device != config.networking.hostName) {
      tower.id = "7ISVGVU-5KITNKD-7SJSM4L-ISNYXCZ-HIRCPFJ-CUMCTSH-WBNYXG3-J6YS2QU";
      lap.id = "2VTLDXN-ZCQG4SM-RJMQ7DV-HIK3KLS-4P2IJ5X-PTGPKMV-XHILX4U-YBVBQQK";
      No2TypeL.id = "6NQRLFY-5TQILNO-OLDZ6PI-5N6UOWX-RNS4DP4-TSNJVRV-HVIUZCP-USLWBQY";
    })
    // {
      # Non NixOS devices
      Pixel.id = "56CEB2H-C65OL2E-DEQ7QNZ-TMA4G7J-L7DOXZS-AHHEDXF-S6POVBO-ULVVFQT";
    };
  deviceNames = builtins.attrNames devices;
in {
  services.syncthing = {
    enable = true;
    dataDir = config.users.users.cblkjs.home;
    openDefaultPorts = true;
    user = "cblkjs";
    group = "users";
    overrideFolders = true;
    overrideDevices = true;
    settings = {
      inherit devices;
      folders = {
        backups = {
          label = "Backups";
          path = "~/phone/backups";
          id = "nf2e5-ftd31";
          devices = deviceNames;
        };
        dcim = {
          label = "DCIM";
          path = "~/phone/dcim";
          id = "pixel_4a_jz65-photos";
          devices = deviceNames;
        };
        music = {
          label = "Music";
          path = "~/Music";
          id = "6ke4a-gkyuu";
          devices = deviceNames;
        };
        obsidian = {
          label = "Obsidian";
          path = "~/Documents/obsidian";
          id = "idagn-qiejp";
          devices = deviceNames;
        };
        seedvaultBackups = {
          label = "Seedvault Backups";
          path = "~/phone/seedvault";
          id = "mm2bw-y7xjo";
          devices = deviceNames;
        };
        pool = {
          label = "pool";
          path = "~/pool";
          id = "qay2w-g9lnh";
          devices = deviceNames;
        };
      };
    };
  };
}
