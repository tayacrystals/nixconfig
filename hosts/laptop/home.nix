{ pkgs, hyprland, ... }:

{
  imports = [
    ../../modules/home/common.nix
    ../../modules/home/desktop/hyprland.nix
  ];

  # Laptop monitor — single display, possibly HiDPI
  # Adjust scale (1.25 or 1.5 for HiDPI) and resolution to match your screen
  # wayland.windowManager.hyprland.settings.monitor = [
  #   "eDP-1,1920x1200@60,0x0,1"
  # ];

  # Touchpad gestures already enabled in hyprland module

  # Laptop-specific packages
  home.packages = with pkgs; [
    # Add laptop-only tools here
  ];
}
