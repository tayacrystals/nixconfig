{ pkgs, lib, ... }:

{
  home.stateVersion = "24.11";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      ll  = "ls -lah";
      g   = "git";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
      nrb = "sudo nixos-rebuild boot --flake /etc/nixos#$(hostname)";
    };

    initExtra = ''
      # Add any extra zsh config here
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$character";
    };
  };

  # Git
  programs.git = {
    enable = true;
    userName  = "taya";
    userEmail = ""; # fill in your email
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
  };

  # Terminal emulator
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
    themeFile = "Catppuccin-Mocha";
  };

  # Common packages
  home.packages = with pkgs; [
    firefox
    vesktop   # Discord client
    neovim
    lazygit
    eza       # modern ls
    bat       # modern cat
    fzf
    zoxide
    yazi      # terminal file manager
  ];

  # Let home-manager manage XDG dirs
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
