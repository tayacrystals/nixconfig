{ pkgs, ... }:

{
  users.users.taya = {
    isNormalUser = true;
    description = "taya";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };

  # Allow sudo without password for wheel (optional — remove if you prefer password)
  security.sudo.wheelNeedsPassword = true;
}
