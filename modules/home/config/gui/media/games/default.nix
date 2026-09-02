{
  lib,
  ...
}:
let
  inherit (lib) mkOption;
  inherit (lib.types) nullOr enum listOf;
in
{
  imports = [
    ./lutris.nix
    ./minecraft.nix
    ./steam.nix
  ];

  options.sylveon.programs.game-clients = mkOption {
    type = nullOr (
      listOf (enum [
        "lutris"
        "minecraft"
        "steam"
      ])
    );
    default = null;
    example = [ "lutris" ];
    description = ''
      ### Steam needs to be installed system-wide, meaning it wont be added here
      which game-clients should be installed
    '';
  };
}
