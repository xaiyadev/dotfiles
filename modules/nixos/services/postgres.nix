{ lib, config, self, pkgs, ... }:
let
    inherit (lib) mkIf mkForce;

    inherit (self.lib.modules) mkPackageOpt;
    cfg = config.sylveon.services.postgres;
in
{
    options.sylveon.services.postgres =
      mkPackageOpt pkgs.postgresql "Postgres databases and stuff";

    config = mkIf cfg.enable {
      services.postgresql = {
        enable = true;
        inherit (cfg) package;

        # Allow access to databases for users with the same username
        authentication = pkgs.lib.mkOverride 10 ''
          #type database DBuser origin-address
          local sameuser  all     peer
          host  sameuser  all     ::1/128 reject
        '';

        # MkForce because something other wants to use 'localhost'
        settings.listen_addresses = mkForce "*";

      };
    };
}
