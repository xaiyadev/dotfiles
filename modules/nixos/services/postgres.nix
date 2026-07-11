{
  lib,
  config,
  self,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkForce mkEnableOption;
  inherit (lib.types) bool;

  cfg = config.sylveon.services.postgres;
in
{
  options.sylveon.services.postgres.enable = mkEnableOption "Enable postgres databases";

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql;

      # Allow access to databases for users with the same username TODO: optimize security?
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