{ lib, pkgs, hostname, ... }: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  # Do garbage collection weekly to keep disk usage low
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    settings = {
      # Manual optimise storage: nix-store --optimise
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;
      builders-use-substitutes = true;

      # enable flakes globally
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh = {
    enable = true;
    settings = {
      # TODO: Research on that
      # X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Power-management
  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  programs.zsh.enable = true;

  environment = {
    systemPackages = with pkgs; [
      git
      wget
      curl
      neovim
    ];
    variables = {
      EDITOR = "nvim";
    };
    shells = with pkgs; [
      bash
      zsh
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;
}
