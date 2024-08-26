{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.adminerevo;
in
{
    options.services.adminerevo = {
        enable = mkEnableOption "custom adminerevo service";

        package = lib.mkOption {
          type = types.package;
          description = "Which package of Adminer to use.";
          default = pkgs.adminerevo;
          defaultText = lib.literalExpression "pkgs.adminerevo";
        };
    };

    config = mkIf cfg.enable {
        # Adminer will only be accessable in local network
        # TODO: learn where it is saved etc.
        environment.systemPackages = with pkgs; [ adminerevo php ];
        processes.adminer.exec = "php -S 8000 -t ${cfg.package} ${cfg.package}/adminer.php";
  };
}