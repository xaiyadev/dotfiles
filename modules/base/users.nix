{
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib.types) listOf str;
  inherit (lib.attrsets) genAttrs;

  inherit (lib)
    forEach
    mkIf
    mkMerge
    mkOption
    ;

  inherit (config.sylveon) users;
in
{
  options.sylveon.users = mkOption {
    type = listOf str;
    default = [ ];
    example = [ "xaiya" ];
    description = ''
      The list of users that should be configured for this system
    '';
  };

  config = {
    # Create users from list
    users.users = genAttrs users (name: {
      initialPassword = "password"; # set password yourself later (IMPORTANT !!)
      isNormalUser = true;

      # same as in nixos/programs/extraPackages.nx
      shell = config.home-manager.users.${name}.programs.zsh.package;

      extraGroups = mkMerge [
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

        (mkIf config.sylveon.profiles.graphical.enable [
          "pipewire"
          "video"
          "audio"
        ])
      ];
    });
  };
}
