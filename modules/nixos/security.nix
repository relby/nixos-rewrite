{ ... }: {
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
  };

  services = {
    power-profiles-daemon.enable = true;
    gnome.gnome-keyring.enable = true;
  };
}
