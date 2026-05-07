{
  inputs,
  config,
  ...
}:
let
  prof = config.sylveon.profiles;
in
{
  # Some catppuccin configuration only work on nixos
  # This file might be changed because the idea of theming will be renewed

  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  config = {
    catppuccin = {
      inherit (prof.graphical) enable;
      cache.enable = true;

      accent = "flamingo";
      flavor = "mocha";
    };
  };
}
