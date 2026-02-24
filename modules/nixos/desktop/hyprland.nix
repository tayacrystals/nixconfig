{ pkgs, hyprland, ... }:

{
  # Hyprland system-level configuration
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  # XDG portals
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Display manager — greetd with tuigreet (lightweight, wayland-friendly)
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      user = "greeter";
    };
  };

  # Needed for screen sharing, screen lock, etc.
  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  environment.systemPackages = with pkgs; [
    # Wayland utilities
    waybar
    wofi             # launcher
    dunst            # notifications
    hyprpaper        # wallpaper
    hyprlock         # screen locker
    hypridle         # idle daemon
    wl-clipboard
    grim             # screenshot
    slurp            # region select
    brightnessctl
    playerctl
    pamixer

    # File manager
    nautilus

    # Theming
    gtk3
    gtk4
    gsettings-desktop-schemas
  ];

  # Ensure dconf works for GTK theming
  programs.dconf.enable = true;
}
