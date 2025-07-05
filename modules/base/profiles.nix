{ self, lib, ... }:
let
  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;
in
{
  options.sylveon.profiles = {

    /* System profiles */

    graphical.enable =
      mkOpt bool false "Enable configurations for graphical systems";

    laptop.enable =
      mkOpt bool false "Enable configurations for laptops";

    server.enable =
      mkOpt bool false "Enable configurations for servers";

    /* Software profiles */

    gaming.enable =
      mkOpt bool false "Configure the system for gaming";

    development.enable =
      mkOpt bool false "Configure the system for development purposes";

  };
}
