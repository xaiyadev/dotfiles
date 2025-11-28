{ inputs, lib, self, config, ... }: 
let
  inherit (lib) mkIf;
  inherit (lib.types) bool;
  inherit (self.lib.modules) mkOpt mkService;

  cfg = config.sylveon.services.atprotocol.tangled.knot;
  knot = config.services.tangled.knot;
in
{

  imports = [ inputs.tangled.nixosModules.knot ];

  options.sylveon.services.atprotocol.tangled.knot = {
    enable = mkOpt bool false "Enable a tangled knot (git repositorys)";
  };

  config = (mkIf cfg.enable (mkService {
    proxy = {
      domain = knot.server.hostname;
      port = "5555";
    };
  } // {

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

 
    # settings.firewall.allowedTCPPorts = [ 22 ]; # TODO: unsecure?
  }));

}
