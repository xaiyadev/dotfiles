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
        sha256 = "sha256-HCp9eC5znXzBPGj9Sa3BJvGphB5v/+b2jTf+FtwvzQc=";
      })
    );
  };
}
