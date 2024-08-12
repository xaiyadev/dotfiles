{ config, lib, ... }:
with lib;
let
    cfg = config.services.postgreSQL;
in
{
    options.services.postgreSQL = {
        enable = mkEnableOption "custom postgreSQL service";
    };

    config = mkIf cfg.enable {

      config.services.postgresql = {
        enable = true;
        ensureUsers = [ "nextcloud" ];
        ensureDatabases = [ "nextcloud" ];
      };
  };
}