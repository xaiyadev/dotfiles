{ self, lib, config, ... }:
let
  inherit (lib.types) listOf str;
  inherit (lib.attrsets) genAttrs;
  inherit (lib.modules) mkDefault;

  inherit (self.lib.modules) mkOpt;
in
{
  options.sylveon.users =
    mkOpt (listOf str) [ "xaiya" ] "A list of users that should be installed";

  config = {
    # Create users from list
    users.users =
      genAttrs config.sylveon.users (
        name: {
          initialPassword = mkDefault "BITTEAENDERN"; # funny # TODO: change to hashedPassword
          isNormalUser = true;
          # shell = pkgs. TODO: create this
          useDefaultShell = true;

          extraGroups = [
            "wheel"
            "nix"
            "docker"
          ];
      });
  };
}
