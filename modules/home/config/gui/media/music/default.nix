{
  lib,
  ...
}:
let
  inherit (lib) mkOption;
  inherit (lib.types) nullOr enum listOf;
in
{
  imports = [
    # -- clients
    ./spotify.nix
    ./tidal.nix
    ./youtube-music.nix

    # -- scrobbler
    ./multi-scrobbler.nix
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
    example = [ "spotify" ];
    description = ''
      Which music players the user should have installed.
    '';
  };
}
