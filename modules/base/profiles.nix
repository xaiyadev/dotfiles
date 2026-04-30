{ lib, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.sylveon.profiles = {
    graphical.enable = mkEnableOption "Graphical Interface and configuration";
    laptop.enable = mkEnableOption "Laptop configuration";
    server.enable = mkEnableOption "services and configurations based on server";
  };
}