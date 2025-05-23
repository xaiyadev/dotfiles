{ self, lib, config, inputs, pkgs, ... }:
let
  inherit (lib.types)
    path
    enum
    nullOr
    str
    package
    ;

  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.theme;
in
{
  options.sylveon.theme = {
    name =
      mkOpt (nullOr (enum [ "rose-pine" ])) null "The theme that should be loaded";

    cursor = {
      name =
        mkOpt (nullOr str) null "The cursor that should be loaded out of the pack";

      package =
        mkOpt (nullOr package) null "Cursor packs package";
    };

    base16 =
      mkOpt path "${inputs.tinted-theming-schemes}/base16/${cfg.name}.yaml" "Path to base16 file for your theme";
  };
}