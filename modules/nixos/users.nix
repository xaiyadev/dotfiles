{ self, lib, config, pkgs, ... }:
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
        name:
        let
          zsh = config.home-manager.users.${name}.sylveon.cli.zsh;
        in
        {
          initialPassword = mkDefault "BITTEAENDERN"; # funny # TODO: change to hashedPassword
          isNormalUser = true;
          shell =
            if zsh.enable then zsh.package else pkgs.bash; # TODO: Change this if there are more shells


          extraGroups = [
            "wheel"
            "nix"
            "docker"
          ];
      });
  };
}
