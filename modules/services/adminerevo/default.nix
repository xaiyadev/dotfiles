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
        networking.firewall.allowedTCPPorts = [ 8000 ];
        # !! Adminer will only be accessable in local network

        environment.systemPackages = with pkgs; [ adminerevo php ];

        systemd.services.adminerevo = {
            enable = true;
            serviceConfig = {
                ExecStart = "php -S 127.0.0.1:8000 -t ${cfg.package} ${cfg.package}/adminer.php";
            };
        };
  };
}