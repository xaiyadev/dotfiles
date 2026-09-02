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
    example = [ "spotify" ];
    description = ''
      Which music players the user should have installed.
    '';
  };
}
