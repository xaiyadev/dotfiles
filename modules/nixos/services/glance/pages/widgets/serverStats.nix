{ lib, config, ... }:
let
  inherit (lib) forEach attrsToList genAttrs;
in
{
  type = "server-stats";
  servers = [
    {
      type = "local";
      name = config.networking.hostName;

      mountpoints = 
        genAttrs 
          (forEach (attrsToList config.fileSystems) (x: x.name)) 
          (name: { "${name}" = { inherit name; }; });
    }
  ];
}
