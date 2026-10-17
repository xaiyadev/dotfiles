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
    ./bottles.nix
    ./minecraft.nix
    ./steam.nix
    ./deadlock.nix
  ];

  options.sylveon.programs.game-clients = mkOption {
    type = nullOr (
      listOf (enum [
        "bottles"
        "minecraft"
        "steam"
        "deadlock"
      ])
    );
    default = null;
    example = [ "bottles" ];
    description = ''
      ### Steam needs to be installed system-wide, meaning it wont be added here
      which game-clients should be installed
    '';
  };
}
