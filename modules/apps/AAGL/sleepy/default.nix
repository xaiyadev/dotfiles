{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.sleepy;
    aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
    options.services.sleepy = {
        enable = mkEnableOption "Zenless Zone Zero launcher for Linux";
    };

    config = mkIf cfg.enable {
        home.packages = [ aagl-gtk-on-nix.sleepy-launcher ];
    };
}