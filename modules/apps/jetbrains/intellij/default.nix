{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.intellij;
in
{
    options.services.intellij = {
        enable = mkEnableOption "custom intellij service";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            jetbrains.idea-ultimate
        ];
    };
}