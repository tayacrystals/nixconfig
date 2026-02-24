{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        type   = "disk";
        device = lib.mkDefault "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size    = "512M";
              type    = "EF00";
              content = {
                type         = "filesystem";
                format       = "vfat";
                mountpoint   = "/boot";
                mountOptions = [ "fmask=0022" "dmask=0022" ];
                extraArgs    = [ "-n" "BOOT" ];
              };
            };
            swap = {
              size    = "8G";
              content = {
                type         = "swap";
                discardPolicy = "both";
                resumeDevice  = true;
              };
            };
            root = {
              size    = "100%";
              content = {
                type      = "btrfs";
                extraArgs = [ "-f" "-L" "nixos" ];
                subvolumes = {
                  "@"          = { mountpoint = "/";           mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@home"      = { mountpoint = "/home";       mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@nix"       = { mountpoint = "/nix";        mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@log"       = { mountpoint = "/var/log";    mountOptions = [ "compress=zstd" "noatime" ]; };
                  "@snapshots" = { mountpoint = "/.snapshots"; mountOptions = [ "compress=zstd" "noatime" ]; };
                };
              };
            };
          };
        };
      };
    };
  };
}
