{ config, lib, pkgs, modulesPath, disko, ... }:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  isoImage.volumeID = lib.mkForce "nixos-installer";
  isoImage.isoName  = lib.mkDefault "nixos-installer.iso";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = lib.mkAfter [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = lib.mkAfter [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # Bundle the flake source into the ISO
  environment.etc."nixos-installer/flake".source =
    pkgs.runCommand "flake-src" {} "cp -rT ${../.} $out";

  environment.etc."nixos-installer/install.sh" = {
    source = ./install.sh;
    mode   = "0755";
  };

  environment.systemPackages = [
    disko.packages.${pkgs.system}.disko
    pkgs.btrfs-progs
    pkgs.git
    pkgs.curl
    pkgs.parted
  ];

  # Service definition — wantedBy is NOT set here; specialisations add it
  systemd.services.nixos-auto-install = {
    description = "Unattended NixOS Installation";
    after  = [ "network-online.target" "getty.target" ];
    wants  = [ "network-online.target" ];
    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      ExecStart       = "${pkgs.bash}/bin/bash /etc/nixos-installer/install.sh";
      StandardOutput  = "journal+console";
      StandardError   = "journal+console";
    };
  };

  # Each specialisation becomes a separate GRUB menu entry in the ISO
  specialisation = {
    "install-workstation".configuration = {
      isoImage.appendToMenuLabel = lib.mkForce " \u2192 Install workstation";
      boot.kernelParams = lib.mkAfter [ "nixos-install.target=workstation" ];
      systemd.services.nixos-auto-install.wantedBy = [ "multi-user.target" ];
    };
    "install-laptop".configuration = {
      isoImage.appendToMenuLabel = lib.mkForce " \u2192 Install laptop";
      boot.kernelParams = lib.mkAfter [ "nixos-install.target=laptop" ];
      systemd.services.nixos-auto-install.wantedBy = [ "multi-user.target" ];
    };
  };
}
