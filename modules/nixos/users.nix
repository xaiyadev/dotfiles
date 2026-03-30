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
  inherit (lib) forEach mkIf mkMerge;

  inherit (lib.modules) mkOption;

  users = config.sylveon.system.users;
in
{
  options.sylveon.system.users = mkOption {
    type = (listOf str);
    default = [];
    example = [ "xaiya" ];
    description = ''
      The list of users that should be configured for this system
    '';
  };

  config = {
    # Generate random passwords for users
    age.secrets = (genAttrs (forEach users (name: "${name}-passwd")) (name: {
      rekeyFile = "${self}/secrets/${name}.age";
      generator.script = "sha256";
    }));

    # Create users from list
    users.users = genAttrs users (
      name:
        {
          hashedPasswordFile = config.age.secrets."${name}-passwd".path;
          isNormalUser = true;
          # shell = config.home-manager.users.${name}.programs.zsh.package; # This might change if introducing multiple shells TODO

          extraGroups =
            (mkMerge
              [
                "wheel"
                "nix"

                "docker"
                "network"
                "networkmanager"
                "input"
                "power"
                "git"
              ]

              (mkIf config.sylveon.profiles.graphical.enable
                [
                  "pipewire"
                  "video"
                  "audio"
                ]
              )
            );
        }
    );
  };
}
