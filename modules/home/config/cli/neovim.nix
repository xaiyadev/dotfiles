{ lib, inputs', config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
in
{
  options.sylveon.programs.neovim.enable = mkEnableOption "Enable my own neovim";

  config = mkIf config.sylveon.programs.neovim.enable {
    sylveon.packages = { neovim =  inputs'.xaivim.packages.default; };
  };
}
