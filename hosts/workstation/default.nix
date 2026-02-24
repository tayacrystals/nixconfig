{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/desktop/hyprland.nix
  ];

  networking.hostName = "workstation";

  # Workstation-specific: no power management needed
  # Add your GPU driver below:
  services.xserver.videoDrivers = [ "nvidia" ]; # or "amdgpu", "intel"

  # If using Nvidia:
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
  };

  # Larger swapfile is fine on a desktop
  # swapDevices = [{ device = "/var/lib/swapfile"; size = 16 * 1024; }];

  system.stateVersion = "24.11";
}
