# Stolen from https://github.com/isabelroses/dotfiles/blob/main/modules/generic/packages.nix
{
  lib,
  config,
  _class,
  ...
}:
let
  inherit (lib) mkOption mergeAttrsList;
  inherit (lib.types) attrsOf package;
in
{
  options.sylveon.packages = mkOption {
    type = attrsOf package;
    default = { };
    description = ''
      A set of packages that should be installed for this system !!
    '';
  };

  # Check if the packages should be installed on system level or user level
  config =
    (if (_class == "nixos") then {
      environment.systemPackages = builtins.attrValues config.sylveon.packages;
    } else {
      home.packages = builtins.attrValues config.sylveon.packages;
    });

}