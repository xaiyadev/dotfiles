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

      wireplumber.extraConfig."51-alsa-dx1ii" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "device.name" = "alsa_card.usb-TOPPING_DX1_II-00"; } ];
            actions = {
              update-props = {
                "device.profile" = "pro-audio";
                "api.alsa.period-size" = 512;
                "api.alsa.period-num" = 3;
                "audio.rate" = 384000;
              };
            };
          }
        ];
      };


      extraConfig = {
        pipewire = {
          # configuration for my Topping DX1 II/Hi-Res bit-perfect streaming
          "default" = {
            "context.properties" = {
              "default.clock.quantum" = 512;
              "default.clock.min-quantum" = 256;
              "default.clock.max-quantum" = 512;
              "default.clock.quantum-limit" = 512;
            };

            "stream.properties" = {
              "resample.quality" = 14;
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
