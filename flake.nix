{
  outputs =
    inputs @ { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , ...
    }:
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
          baseArgs = {
            inherit home-manager;
            nixpkgs = nixpkgs-unstable; # or nixpkgs for stable 23.05 version
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs username hostname;
              # use unstable branch for some packages to get the latest updates
              pkgs-unstable = import nixpkgs-unstable {
                # TODO: move it to a variable
                system = "x86_64-linux";
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

    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    wezterm-nightly = {
      url = "github:happenslol/wezterm/add-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    }

    # Consider using it later
    # nixos-hardware.url = "github:nixos/nixos-hardware";
  };
}
