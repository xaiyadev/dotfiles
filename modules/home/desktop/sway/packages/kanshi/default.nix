{ lib, osConfig, ... }:
let
  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
in {

  imports = [
    ./docked_office.nix
    ./docked_home.nix
  ];

  services.kanshi.enable = builtins.elem "sway" windowManagers;
}