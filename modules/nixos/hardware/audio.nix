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

    services.pulseaudio.enable = lib.mkForce false;

    services.pipewire = {
      enable = true;

      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true; # Alsa very nice for exclusive mode
        support32Bit = true;
      };

      extraLadspaPackages = [ pkgs.rnnoise-plugin ];

      extraConfig.pipewire = {
        "10-loopback" = {
          "context.modules" = [{
              "node.description" = "playback loop";
              "audio.position" = [
                "FL"
                "FR"
              ];

              "capture.props" = {
                "node.name" = "playback_sink";
                "node.description" = "playback-sink";
                "media.class" = "Audio/Sink";
              };

              "playback.props" = {
                "node.name" = "playback_sink.output";
                "node.description" = "playback-sink-output";
                "media.class" = "Audio/Source";
                "node.passive" = true;
              };
          }];
        };
      };
    };

    systemd.user.services = {
      pipewire.wantedBy = [ "default.target" ];
      pipewire-pulse.wantedBy = [ "default.target" ];
    };

  };
}
