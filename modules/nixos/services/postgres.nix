{
  lib,
  config,
  self,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;
  cfg = config.sylveon.services.postgres;
in
{
  options.sylveon.services.postgres = {
    enable = mkOpt bool false "Enable postgres databases mkService";
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;

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
