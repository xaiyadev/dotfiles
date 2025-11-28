{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  inherit (lib.types) bool;

  inherit (self.lib.modules)
    mkOpt
    mkService
    ;

  cfg = config.sylveon.services.glance;
in
{

  options.sylveon.services.glance = {
    enable = mkOpt bool false "Enable web dashboard application";
  }; 

  config = (mkIf cfg.enable (mkService {
    secrets = [{ name = "glance-env"; }];

    proxy = {
      name = "xaiya.dev";
      port = (toString config.services.glance.settings.server.port);
    };
  } // {

    services.glance = {
      enable = true;
      openFirewall = false; # Managed through nginx server

      environmentFile = config.age.secrets.glance-env.path;

      settings = {
        pages = [
          (import ./pages/overview.nix { config = config; lib = lib; })
        ];

        server = {
          host = ""; # Needs to be an empty string, otherwise interfaces cant be found correctly
          port = 8002;
          proxied = true;
        };

        # rose-pine color theme
        theme = {
          constrat-multiplier = 1.3;
          background-color = "249 22 12"; # Base
          pirmary-color = "245 50 91"; # Text
          positive-color = "2 55 83"; # Rose
          negative-color = "343 76 68"; # Love
        };
      };
    };

  }));
}
