{ lib, config, ... }:
let
  inherit (lib) 
    mkEnableOption
    mkIf
    ;
in
{
  options.sylveon = {
    profiles = {
      graphical.enable = mkEnableOption "Graphical Interface and configuration";
      laptop.enable = mkEnableOption "Laptop configuration";
      server.enable = mkEnableOption "services and configurations based on server";
    };

    devices = {
      framework.enable = mkEnableOption "load services and configuration needed for/helping framework";
    };
  };
}
