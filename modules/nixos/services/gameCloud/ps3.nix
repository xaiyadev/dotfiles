{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;

  cfg = config.sylveon.services.gameCloud;
in
{
  # TODO: globafy this?
  config = mkIf cfg.enable {
    sylveon.packages = { inherit (pkgs) ps3netsrv; };
    networking.firewall.allowedTCPPorts = [ 38008 ]; # allow ps3netsrv port

    systemd.services.ps3netsrv = {
      description = "PS3 Net Server";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${getExe pkgs.ps3netsrv} /mnt/storage/games/ps3";
        Restart = "on-failure";
        DynamicUser = true;
      };
    };
  };
}
