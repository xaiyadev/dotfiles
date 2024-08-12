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

      services.postgresql = {
        enable = true;
        ensureUsers = 
	[ 
	  {
	    name = "nextcloud";	
	  }

	];
        ensureDatabases = [ "nextcloud" ];
      };
  };
}
