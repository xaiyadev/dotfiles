{ osConfig, ... }:
{
  imports = [
    ../generic
    ./config # configuration the defaults for most users

    ./environment
    ./programs

    ./docs.nix
    ./style.nix
  ];

  config = {
    home.stateVersion = osConfig.system.stateVersion;
  };
}
