{
  osConfig,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  # Use the global catppuccin configuration
  # TODO: applications that need to be manaul integrated/need nix integration
  config = mkIf osConfig.catppuccin.enable {
    catppuccin = {
      enable = true;

      inherit (osConfig.catppuccin)
        accent
        flavor
        ;
    };
  };
}
