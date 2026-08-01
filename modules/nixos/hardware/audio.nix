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
      inherit (pkgs) pwvucontrol;
    };

    # we dont wanna use pulse audio, only pipewire
    services.pulseaudio.enable = lib.mkForce false;

    services.pipewire = {
      enable = true;

      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      extraLadspaPackages = [ pkgs.rnnoise-plugin ];
      
      extraConfig.pipewire = {
        # configuration for my FiiO Btr5
        "hires" = {
          "context.properties" = {
            "default.clock.rate" = 44100;
            "default.clock.allowed-rates" = [ 32000 64000 128000 44100 48000 88200 96000 176400 192000 352800 384000 ];
          };
          
          "stream.properties" = {
            "resample.quality" = 14;
          };  

        };
      };

    };

    systemd.user.services = {
      pipewire.wantedBy = [ "default.target" ];
      pipewire-pulse.wantedBy = [ "default.target" ];
    };

  };
}
