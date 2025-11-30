{ inputs, lib, self, config, ... }: 
let
  inherit (lib) mkIf;
  inherit (lib.types) bool;
  inherit (self.lib.modules) mkOpt mkService;

  cfg = config.sylveon.services.atprotocol.tangled.spindle;
  spindle = config.services.tangled.spindle;
in
{

  imports = [ inputs.tangled.nixosModules.spindle ];
  options.sylveon.services.atprotocol.tangled.spindle = {
    enable = mkOpt bool false "Enable a tangled spindle (pipelines)";
  };

  config = (mkIf cfg.enable (mkService {
    proxy = {
      domain = spindle.server.hostname;
      port = "6555";
    };
  } // {
    services.tangled.spindle = {
      enable = true;

      server = {
        hostname = "spindle.xaiya.dev";
        owner = "did:plc:mycafjhyplj5z7a6qi5qjcil"; # TODO: change if new PDS
      };
    };
 
    # settings.firewall.allowedTCPPorts = [ 22 ]; # TODO: unsecure?
  }));
}
