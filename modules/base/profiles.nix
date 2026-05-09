{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.sylveon.profiles = {
    graphical.enable = mkEnableOption "Graphical Interface and configuration";
    gaming.enable = mkEnableOption "Configuration for devices you want to game on";
    laptop.enable = mkEnableOption "Laptop configuration";
    server.enable = mkEnableOption "services and configurations based on server";
  };
}
