{ config, self, lib, ... }:
let
  inherit (lib) mkIf;

  graphical = config.profiles.graphical;
in
{
  config = mkIf graphical.enable {
    # Using pipewire as my sound backend
    services.pipewire = {
      enable = true;

      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };


    };
  };
}