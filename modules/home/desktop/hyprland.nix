{ pkgs, lib, ... }:

{
  # Hyprland home-manager configuration
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      # Monitors — adjust to your actual setup
      # Run `hyprctl monitors` to get names
      monitor = [
        ",preferred,auto,1"   # auto-detect, 1x scale (change scale for HiDPI)
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ff) rgba(89b4faff) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
        };
        shadow = {
          enabled = true;
          range = 8;
          render_power = 2;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      gestures.workspace_swipe = true;

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # Keybindings — $mod is SUPER
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating"
        "$mod, R, exec, wofi --show drun"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

        # Move focus
        "$mod, left,  movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up,    movefocus, u"
        "$mod, down,  movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, Print, exec, grim - | wl-copy"

        # Screen lock
        "$mod, L, exec, hyprlock"
      ];

      bindm = [
        # Move/resize with mouse
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        # Volume / brightness (held)
        ", XF86AudioRaiseVolume,  exec, pamixer -i 5"
        ", XF86AudioLowerVolume,  exec, pamixer -d 5"
        ", XF86AudioMute,         exec, pamixer -t"
        ", XF86MonBrightnessUp,   exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      exec-once = [
        "waybar"
        "dunst"
        "hyprpaper"
        "hypridle"
      ];

      windowrulev2 = [
        "float, class:^(nautilus)$"
        "float, class:^(pavucontrol)$"
        "float, title:^(Picture-in-Picture)$"
      ];
    };
  };

  # Waybar
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      modules-left   = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right  = [ "pulseaudio" "network" "battery" "tray" ];

      "hyprland/workspaces".on-click = "activate";
      clock.format = "%a %b %d  %H:%M";
      battery = {
        format = "{capacity}% {icon}";
        format-icons = [ "" "" "" "" "" ];
        states = { warning = 30; critical = 15; };
      };
      network = {
        format-wifi      = " {signalStrength}%";
        format-ethernet  = " {ifname}";
        format-disconnected = "⚠ Disconnected";
        tooltip-format   = "{ifname}: {ipaddr}";
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "  0%";
        format-icons.default = [ "" "" "" ];
        on-click = "pavucontrol";
      };
    }];
  };

  # Hyprlock (screen locker)
  programs.hyprlock = {
    enable = true;
    settings = {
      general.grace = 5;
      background = [{
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        blur_size = 7;
      }];
      input-field = [{
        monitor = "";
        size = "250, 50";
        position = "0, -80";
        halign = "center";
        valign = "center";
        outer_color = "rgb(cba6f7)";
        inner_color = "rgb(1e1e2e)";
        font_color = "rgb(cdd6f4)";
        placeholder_text = "Password...";
      }];
    };
  };

  # Hypridle (idle management)
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd   = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd          = "hyprlock";
      };
      listener = [
        { timeout = 300; on-timeout = "hyprlock"; }
        { timeout = 360; on-timeout = "hyprctl dispatch dpms off"; on-resume = "hyprctl dispatch dpms on"; }
      ];
    };
  };

  # GTK theming (Catppuccin Mocha)
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard+default";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 24;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Catppuccin-Mocha-Dark-Cursors";
    XCURSOR_SIZE  = "24";
    GDK_BACKEND   = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
}
