{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      # TODO: Try to use it
      # xdg-desktop-portal-hyprland
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

      enableNvidiaPatches = true;
    };
    light.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      waybar # Status bar
      swww
      swayidle # Idle timeout
      swaylock # Screen locking
      wlogout # Logout menu
      wl-clipboard
      networkmanagerapplet # nm-connection-editor
    ];
    pathsToLink = [ "/libexec" ];
  };

  security.pam.services = {
    swaylock = { };
  };
}
