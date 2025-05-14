{ self, lib, config, pkgs, ... }:
let
  inherit (lib.types) listOf str;
  inherit (lib.attrsets) genAttrs;
  inherit (lib) forEach;

  inherit (self.lib.modules) mkOpt;
in
{
  options.sylveon.users =
    mkOpt (listOf str) [ "xaiya" ] "A list of users that should be installed";

  config = {
    # Generate random passwords for users
    age.secrets =
      genAttrs
        (forEach config.sylveon.users (name: "${name}-passwd"))
        (name: { rekeyFile = "${self}/secrets/${name}.age"; generator.script = "ranSha256"; });

    # Create users from list
    users.users =
      genAttrs config.sylveon.users (
        name:
        let
          zsh = config.home-manager.users.${name}.sylveon.cli.zsh;
        in
        {
          initialPassword = "BITTEAENDERN";
          # hashedPasswordFile = config.age.secrets."${name}-passwd".path;
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
