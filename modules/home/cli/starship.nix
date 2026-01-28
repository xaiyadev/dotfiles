{ lib, ... }:
let
  inherit (builtins)
    fromTOML
    readFile
    fetchurl
    ;
in
{
  programs.starship = {
    enable = true;

    settings = fromTOML (
      readFile (fetchurl {
        url = "https://starship.rs/presets/toml/bracketed-segments.toml";
        sha256 = "sha256-FQHzfWYEcllLCmH2nx52J31Jw8Yy6aDAoOVdxWxhcAU="; # TODO: make this auto update? (versioned)
      })
    );
  };
}
