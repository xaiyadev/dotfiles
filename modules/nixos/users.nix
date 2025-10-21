{
  self,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.types) listOf str;
  inherit (lib.attrsets) genAttrs;
  inherit (lib) forEach;

  inherit (self.lib.modules) mkOpt;
  inherit (self.lib.validation) hasHomeModule;

  users = config.sylveon.system.users;
in
{
  options.sylveon.system.users = mkOpt (listOf str) [ ] "A list of users that should be installed";

  config = {
    # Generate random passwords for users
    age.secrets = genAttrs (forEach users (name: "${name}-passwd")) (name: {
      rekeyFile = "${self}/secrets/${name}.age";
      generator.script = "sha256";
    });

    # Create users from list
    users.users = genAttrs users (
      name:
      {
        hashedPasswordFile = config.age.secrets."${name}-passwd".path;
        isNormalUser = true;
        shell = config.home-manager.users.${name}.programs.zsh.package; # This might change if introducing multiple shells

        extraGroups = [
          "wheel"
          "nix"
          "docker"

          "video"
          "audio"
        ];
      }
    );
  };
}
