{ osConfig, ... }: {
   home.stateVersion = osConfig.system.stateVersion; # Use the stateVersion of the system

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

}
