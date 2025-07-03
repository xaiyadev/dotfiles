{ lib, osConfig, ... }:
let
  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
in {

  imports = [
    ./docked_home.nix
    ./docked_office.nix
    ./docked_second_office.nix
    ./docked_third_office.nix
  ];

  services.kanshi.enable = builtins.elem "sway" windowManagers;
}