{ lib, config, pkgs, inputs', inputs, ... }:
let
  inherit (lib) mkIf;

  discord-music-presence = inputs'.xaipkgs.packages.discord-music-presence.overrideAttrs (_:{ # scrobbeling + discord-status
    version = "2.4.0";
    src = "${inputs.musicpresence}/musicpresence-2.4.0-beta.10-linux-x86_64.tar.gz";
  });
in
{
  config = mkIf config.sylveon.profiles.user.music.enable {
    sylveon.packages = {
      inherit (pkgs)
        pear-desktop # Youtube music
        high-tide # tidal
        ;

      inherit discord-music-presence;
    };
  };
}
