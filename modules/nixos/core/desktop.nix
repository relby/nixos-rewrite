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

  # TODO: set to true and configure
  networking.firewall.enable = false;

  programs = {
    dconf.enable = true;
  };

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    # TODO: Research on gvfs and tumbler
    gvfs.enable = true;
    tumbler.enable = true;

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };
      excludePackages = with pkgs; [ xterm ];
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
    # TODO: Maybe set this to false in future
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
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
