{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf config.sylveon.profiles.graphical.enable {
    services.easyeffects = {
      enable = true;
      preset = "preset";

      extraPresets = {
        preset = builtins.fromJSON (builtins.readFile ./preset.json);
      };
    };
  };
}
