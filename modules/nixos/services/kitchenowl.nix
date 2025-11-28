{
  lib,
  config,
  self,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt mkService;
  cfg = config.sylveon.services.plex;
  port = "8050";
in
{
  options.sylveon.services.kitchenowl.enable =
    mkOpt bool false
      "cooking book (still maintend on docker)"; # TODO

  config = (mkIf cfg.enable (mkService {
    secrets = [{ name = "kitchenowl.env"; }];
    proxy = { inherit port; domain = "kitchen.xaiya.dev"; };
  } // {
    virtualisation.oci-containers.containers.kitchenowl = {
      image = "tombursch/kitchenowl:latest";
      ports = [ "${port}:${port}" ];

      environmentFiles = [ config.age.secrets.kitchenowl-env.path ];
      volumes = [ "/mnt/raid/services/kitchenowl/data:/data" ];
    };
  } ));
}
