{ lib, osConfig, ... }:

let
  inherit (lib)
    mkIf
    ;

  inherit (osConfig.sylveon.graphical) sway;
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
