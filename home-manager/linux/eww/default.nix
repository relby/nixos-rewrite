{ inputs, pkgs, ... }: {
  programs.eww = {
    enable = true;
    package = inputs.nixpkgs-wayland.packages.x86_64-linux.eww-wayland;
    configDir = ./config;
  };
}
