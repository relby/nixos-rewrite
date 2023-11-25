{ inputs, pkgs, username, ... }: {
  imports = [
    ./hyprland
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    packages = with pkgs; [
      # TODO: Replace with `inputs.wezterm-nightly.packages.x86_64-linux.default` after switching to unstable
      inputs.wezterm-nightly.packages.x86_64-linux.default
      # wezterm
      alacritty
      cargo
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
