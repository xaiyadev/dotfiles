{ self, lib, config, inputs, ... }:
let
  inherit (lib.types) path enum nullOr;

  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.theme;
in
{
  options.sylveon.theme = {
    name =
      mkOpt (nullOr (enum [ "rose-pine" ])) null "The theme that should be loaded"; # TODO: per user?

    base16 =
      mkOpt path "${inputs.tinted-theming-schemes}/base16/${cfg.name}.yaml" "Path to base16 file for your theme";
  };
}