{
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
in
{
  # TODO: add array option
  options.sylveon.services.gameCloud.enable = mkEnableOption "Whether or not to enable saves and content in game clouds";

  imports = [
    ./ps3.nix
  ];

}
