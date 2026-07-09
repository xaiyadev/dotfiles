{
  lib,
  config,
  inputs',
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkOption getExe;
  inherit (lib.lists) any;
  inherit (lib.types) nullOr enum listOf;

  players = config.sylveon.programs.music-players;

  discord-music-presence = inputs'.xaipkgs.packages.discord-music-presence.overrideAttrs (_: {
    version = "2.4.0";
    src = "${inputs.private-files}/musicpresence-2.4.0-beta.10-linux-x86_64.tar.gz";
  });

in
{
  imports = [
    ./spotify.nix
    ./tidal.nix
    ./youtube-music.nix
  ];

  options.sylveon.programs.music-players = mkOption {
    type = nullOr (
      listOf (enum [
        "spotify"
        "tidal"
        "youtube-music"
      ])
    );
    default = null;
    example = "spotify";
    description = ''
      Which music players the user should have installed.
    '';
  };

  config = (mkIf (any (x: x != "spotify") players)) {
    # install packages for scrobelling music data
    sylveon.packages = { inherit discord-music-presence; };
    wayland.windowManager.sway.config.startup = [ { command = getExe discord-music-presence; } ];
  };
}
