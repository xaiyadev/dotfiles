{ config, self, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];

    banner = ''
      You have connected to ${config.sylveon.device.name} @ NixOS (v ${config.system.nixos.release})"

      This is part of the sylveon flake network! :>
    '';

    settings = {
      PermitRootLogin = "no";
    };

    knownHosts = {
      "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
  };

  # Load ssh keys
  age.secrets = {
    "ssh-gh" = { # Github
      rekeyFile = "${self}/secrets/ssh-gh.age"; # Loading github ssh key
      mode = "644";
      group = "users";
    };

    "ssh-bb" = { # Bitbucket
      rekeyFile = "${self}/secrets/ssh-bb.age"; # Loading github ssh key
      mode = "644";
      group = "users";
    };

  };
}