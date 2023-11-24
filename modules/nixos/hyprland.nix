{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  services = {
    # TODO: Research on gvfs and tumbler
    gvfs.enable = true;
    tumbler.enable = true;

    xserver = {
      enable = true;

      displayManager = {
        defaultSession = "hyprland";
        lightdm.enable = false;
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      
      nvidiaPatches = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      waybar # Status bar
      swww
      swayidle # Idle timeout
      swaylock # Screen locking
      wlogout # Logout menu
      wl-clipboard
      mako # Notification daemon
      networkmanagerapplet # nm-connection-editor
    ];
    pathsToLink = [ "/libexec" ];
  };

  security.pam.services.swaylock = {};
}
