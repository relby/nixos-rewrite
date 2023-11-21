{ config, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      modesetting.enable = true;
      open = false;
      powerManagement.enable = true;
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  virtualisation.docker = {
    enableNvidia = true;
  };
}
