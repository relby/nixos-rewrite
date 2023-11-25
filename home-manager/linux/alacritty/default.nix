{ ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        # Fullscreen, because startup_mode doesn't work on wayland display
        startup_mode = "Maximized";
      };
      font =
        let family = "Iosevka Nerd Font";
        in
        {
          normal = { inherit family; style = "Regular"; };
          bold = { inherit family; style = "Bold"; };
          italic = { inherit family; style = "Italic"; };
          bold_italic = { inherit family; style = "Bold Italic"; };
          size = 16;
        };
    };
  };
}
