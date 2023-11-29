{
  outputs =
    inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, nixpkgs-wayland, ... }:
    let
      username = "relby";
      # Consider changing it later
      hostname = "nixos";

      modulesHyprland = {
        nixos-modules = [ ./hosts/laptop ];
        home-module = import ./home-manager/linux/desktop-hyprland.nix;
      };

      lib = import ./lib;
    in
    {
      nixosConfigurations =
        let
          baseArgs = let system = "x86_64-linux"; in
            {
              inherit system;
              home-manager = home-manager-unstable; # or home-manager for stable 23.05 version
              nixpkgs = nixpkgs-unstable; # or nixpkgs for stable 23.05 version
              # TODO: add overlays after this `https://github.com/nix-community/nixpkgs-wayland/pull/431` PR is merged
              overlays = [ /* nixpkgs-wayland.overlay */ ];
              specialArgs = {
                inherit inputs username hostname;
                # use unstable branch for some packages to get the latest updates
                pkgs-unstable = import nixpkgs-unstable {
                  inherit system;
                  # To use chrome, we need to allow the installation of non-free software
                  config.allowUnfree = true;
                };
              } // inputs;
            };
        in
        {
          ${hostname} = lib.mkNixOS (modulesHyprland // baseArgs);
        };
    };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    wezterm-nightly = {
      url = "github:relby/wezterm/add-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
  };
}
