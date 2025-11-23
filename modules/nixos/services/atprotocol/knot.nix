{ inputs, lib, self, config, ... }: 
let
  inherit (lib) mkIf;

  inherit (self.lib.modules) mkPackageOpt;
  cfg = config.sylveon.services.atprotocol.tangled.knot;
  knot = config.services.tangled.knot;
in
{

  imports = [ inputs.tangled.nixosModules.knot ];
  options.sylveon.services.atprotocol.tangled.knot = mkPackageOpt null "Tangled knot for git repos";

  config = mkIf cfg.enable {
    services.tangled.knot = {
      enable = true;

      server = {
        hostname = "knot.xaiya.dev";
        owner = "did:plc:mycafjhyplj5z7a6qi5qjcil"; # TODO: change if new PDS
      };

      motd = ''
        >> Tangled Knot !! (owned by: ${knot.server.owner})
      '';
    };

    services.nginx.virtualHosts.${knot.server.hostname} = {
      enableACME = true;
      forceSSL = true;

      locations."/".proxyPass = "http://127.0.0.1:5555";
      extraConfig = "proxy_ssl_server_name on;";
    };
 
    # settings.firewall.allowedTCPPorts = [ 22 ]; # TODO: unsecure?
  };
}
