{ config, self, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];

    banner = ''
      You have connected to ${config.networking.hostName} @ NixOS (v ${config.system.nixos.release})"

      This is part of the sylveon flake network! :>
    '';

    settings = {
      PermitRootLogin = "no";
    };
  };

  # Load ssh keys
  age.secrets = {
    "ssh-gh" = {
      # Github
      rekeyFile = "${self}/secrets/ssh-gh.age"; # Loading github ssh key
      mode = "644";
      group = "users";
    };

    "ssh-bb" = {
      # Bitbucket
      rekeyFile = "${self}/secrets/ssh-bb.age"; # Loading github ssh key
      mode = "644";
      group = "users";
    };

  };
}
