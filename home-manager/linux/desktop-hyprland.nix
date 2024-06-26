{ inputs, pkgs, username, ... }: {
  imports = [
    ./alacritty
    ./shell
    ./git
    ./starship
    ./neovim
    ./gtk
    ./eww
    ./hyprland
    ./hyprshade
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    packages = with pkgs; [
      # TODO: `wezterm` doesn't work for now for some reason. Switch to it from alacritty after the problem goes away
      # inputs.wezterm-nightly.packages.x86_64-linux.default
      # wezterm
      alacritty
      rustup

      google-chrome
      nodejs_20
      python311
      jq

      feh
      imv
      libnotify
      grim
      slurp
      go
      lazygit

      dotnet-sdk_8
      vscode-fhs
      sqlc

      nodePackages."@nestjs/cli"
      nodePackages."pnpm"
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

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "Sublime Snazzy";
      };
    };
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    eza = {
      enable = true;
      enableAliases = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
    zoxide.enable = true;

    nix-index = {
      enable = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
