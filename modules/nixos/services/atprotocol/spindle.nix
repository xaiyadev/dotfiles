{ inputs, lib, self, config, ... }: 
let
  inherit (lib) mkIf;

  inherit (self.lib.modules) mkPackageOpt;
  cfg = config.sylveon.services.atprotocol.tangled.knot;
  spindle = config.services.tangled.spindle;
in
{

  imports = [ inputs.tangled.nixosModules.spindle ];
  options.sylveon.services.atprotocol.tangled.spindle = mkPackageOpt null "Tangled knot for git repos";

  config = mkIf cfg.enable {
    services.tangled.spindle = {
      enable = true;

      server = {
        hostname = "spindle.xaiya.dev";
        owner = "did:plc:mycafjhyplj5z7a6qi5qjcil"; # TODO: change if new PDS
      };
    };

    services.nginx.virtualHosts.${spindle.server.hostname} = {
      enableACME = true;
      forceSSL = true;

      locations."/".proxyPass = "http://127.0.0.1:6555";
      extraConfig = "proxy_ssl_server_name on;";
    };
 
    # settings.firewall.allowedTCPPorts = [ 22 ]; # TODO: unsecure?
  };
}
