{ osConfig, ... }:
{
  imports = [
    ./desktop # Desktop specific configuration and theming
    ./programs
    ./cli
  ];

  config = {
    home.stateVersion = osConfig.system.stateVersion;
  };
}
