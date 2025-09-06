{
  config,
  self,
  lib,
  ...
}:
let
  inherit (lib) mkIf;

  prof = config.sylveon.profiles;
in
{
  config = mkIf prof.graphical.enable {

    # Using pipewire as my sound backend
    services.pipewire = {
      enable = true;

      pulse.enable = true;
      alsa.enable = true;

    };
  };
}
