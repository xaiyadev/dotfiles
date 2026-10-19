_:
let
  inherit (builtins)
    fromTOML
    readFile
    fetchurl
    ;
in
{
  programs.starship = {
    # TODO: configure self
    enable = true;

    settings = fromTOML (
      readFile (fetchurl {
        url = "https://starship.rs/presets/toml/bracketed-segments.toml";
        sha256 = "sha256-KnR7aSTtRGiBV1HqXsKldezra7dIlq6XbhLIgjplF7w=";
      })
    );
  };
}
