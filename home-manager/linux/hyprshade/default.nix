{ pkgs, ... }: {
  home.packages = with pkgs; [
    hyprshade
  ];

  xdg.configFile."hypr/shaders" = {
    source = ./shaders;
    recursive = true;
  };
}
