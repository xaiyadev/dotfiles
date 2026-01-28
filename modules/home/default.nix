{ osConfig, ... }:
{
  imports = [
    ./gui
    ./cli
    ./tui

    ./style.nix # Style configuration
  ];

  config = {
    home.stateVersion = osConfig.system.stateVersion;
  };
}
