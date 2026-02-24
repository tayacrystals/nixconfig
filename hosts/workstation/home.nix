{ pkgs, hyprland, ... }:

{
  imports = [
    ../../modules/home/common.nix
    ../../modules/home/desktop/hyprland.nix
  ];

  # Override monitor config for workstation (multi-monitor example)
  # wayland.windowManager.hyprland.settings.monitor = [
  #   "DP-1,2560x1440@165,0x0,1"
  #   "DP-2,1920x1080@60,2560x0,1"
  # ];

  # Workstation-specific packages
  home.packages = with pkgs; [
    # Add workstation-only tools here
  ];
}
