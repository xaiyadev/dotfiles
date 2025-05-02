{ config, self, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (self.lib.validation) isGraphical;

in
{
  config = mkIf (isGraphical config) {
    # Using pipewire as my sound backend
    services.pipewire = {
      enable = true;

      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;

      # TODO: add extra configuration

    };
  };
}