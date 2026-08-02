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

      wireplumber.extraConfig."51-alsa-btr5" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "device.name" = "alsa_card.usb-FiiO_FiiO_BTR5-00"; } ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
                "api.alsa.period-size" = 64;
                "api.alsa.period-num" = 3;
                "audio.rate" = 44100;
              };
            };
          }
        ];
      };
      
      
      extraConfig = {
        pipewire = {
          # configuration for my FiiO Btr5/Hi-Res streaming
          "hires" = {
            "context.properties" = {
              "default.clock.rate" = 44100;
              "default.clock.allowed-rates" = [ 44100 ];
          
              "default.clock.quantum" = 64;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 64;
              "default.clock.quantum-limit" = 64;
            };
            
            "stream.properties" = {
              "resample.quality" = 14;
            };  
          
          };
        };

        pipewire-pulse = {
          "hires-pulse" = {
            "pulse.properties" = {  
              "pulse.min.req"     = "64/44100";
              "pulse.default.req" = "64/44100";
              "pulse.min.frag"    = "64/44100";
              "pulse.default.frag" = "64/44100";
              "pulse.min.quantum" = "64/44100";
            };
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
