{
  mkNixOS =
    { nixpkgs
    , home-manager
    , system
    , specialArgs
    , nixos-modules
    , home-module
    , overlays
    }:
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules = nixos-modules ++ [
        {
          nix = {
            # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
            registry.nixpkgs.flake = nixpkgs;
            settings = {
              trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
              ];
              substituters = [
                "https://cache.nixos.org"
                "https://nixpkgs-wayland.cachix.org"
              ];
            };
          };

          nixpkgs.overlays = overlays;

          # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
          environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
          nix.nixPath = [ "/etc/nix/inputs" ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            users."${specialArgs.username}" = home-module;
          };
        }
      ];
    };
}
