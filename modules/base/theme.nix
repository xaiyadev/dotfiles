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

  cfg = config.sylveon.system.theme;
in
{
  options.sylveon.system.theme = {
    name =
      mkOpt (nullOr (enum [ "rose-pine" ])) null "The theme that should be loaded";

    base16 =
      mkOpt path "${inputs.tinted-theming-schemes}/base16/${cfg.name}.yaml" "Path to base16 file for your theme";
  };
}