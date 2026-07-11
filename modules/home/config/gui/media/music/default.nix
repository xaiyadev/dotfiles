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
    sylveon.packages = { inherit (inputs'.xaipkgs.packages) discord-music-presence; };
    wayland.windowManager.sway.config.startup = [ { command = getExe inputs'.xaipkgs.packages.discord-music-presence; } ];
  };
}
