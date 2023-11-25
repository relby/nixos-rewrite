{ ... }: {
  programs = {
    bash = {
      enable = true;
      enableVteIntegration = true;
    };
    nushell = {
      enable = true;
      # TODO: Configure nushell
    };
  };
}
