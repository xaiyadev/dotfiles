{ lib, osConfig, pkgs, ... }:

let
  inherit (lib)
    mkIf
    getExe
    ;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  imports = [
    ./docked_home.nix
    ./docked_office.nix
  ];

  config = mkIf sway.enable {
    services.kanshi.enable = true;
  };
}
