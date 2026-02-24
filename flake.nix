{
  description = "taya's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, disko, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    mkHost = hostname: extraModules: lib.nixosSystem {
      inherit system;
      specialArgs = { inherit self hyprland; };
      modules = [
        disko.nixosModules.disko
        ./hosts/${hostname}/disko.nix
        ./hosts/${hostname}/default.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs    = true;
            useUserPackages  = true;
            extraSpecialArgs = { inherit hyprland; };
            users.taya       = import ./hosts/${hostname}/home.nix;
          };
        }
      ] ++ extraModules;
    };
  in {
    nixosConfigurations = {
      workstation = mkHost "workstation" [];
      laptop      = mkHost "laptop"      [];

      installer = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit disko; };
        modules = [ ./installer/iso.nix ];
      };
    };

    packages.${system} = {
      installer-iso =
        self.nixosConfigurations.installer.config.system.build.isoImage;
    };
  };
}
