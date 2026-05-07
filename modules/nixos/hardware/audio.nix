{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  prof = config.sylveon.profiles;
in
{
  config = mkIf prof.graphical.enable {
    sylveon.packages = {
      inherit (pkgs)
        qpwgraph
        pwvucontrol
        ;
    };

    services.pipewire = {
      enable = true;

      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;

      alsa = {
        enable = true; # Alsa very nice for exclusive mode
        support32Bit = true;
      };
    };
  };
}
