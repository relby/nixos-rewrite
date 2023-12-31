{ pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = with pkgs; [
    pulseaudio
    playerctl
  ];

  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  # Set `sound.enable` to `false`, because it can cause conflicts with pipewire
  sound.enable = false;
  # Disable pulseaudio, it also can cause conflicts with pipewire
  hardware.pulseaudio.enable = false;
}
