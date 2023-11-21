{ pkgs, config, hyprland, ... }: {
  imports = [
    ./server.nix

    ../sound.nix
    ../bluetooth.nix
    ../security.nix
  ];

  environment = {
    variables = {
      # fix https://github.com/NixOS/nixpkgs/issues/238025
      TZ = "${config.time.timeZone}";
    };
  };

  programs = {
    dconf.enable = true;
  };

  services = {
    printing.enable = true;

    # TODO: Research on gvfs and tumbler
    gvfs.enable = true;
    tumbler.enable = true;

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };
    };
  };

  xdg.portal = {
    enable = true;
    # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
    # This will make xdg-open use the portal to open programs,
    # which resolves bugs involving programs opening inside FHS envs or with unexpected env vars set from wrappers.
    # xdg-open is used by almost all programs to open a unknown file/uri
    # alacritty as an example, it use xdg-open as default, but you can also custom this behavior
    # and vscode has open like `External Uri Openers`
    xdgOpenUsePortal = false;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  fonts = {
    enableDefaultFonts = false;
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "Iosevka"
        ];
      })
    ];
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };
}
