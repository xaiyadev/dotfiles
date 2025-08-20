{ lib, osConfig, ... }:

let
  inherit (lib)
    mkIf
    concatStringsSep
    ;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  imports = [
    ./docked_home.nix
    ./docked_office.nix
    ./docked_second_office.nix
    ./docked_third_office.nix
    ./docked_fourth_office.nix
  ];

  config = mkIf sway.enable {
    services.kanshi.enable = sway.enable;
  };
}
