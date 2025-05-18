{ config, self, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];

    # TODO: add rev/version tag as variable
    banner = ''
      You have connected to ${config.networking.hostName} @ v5"

      This is part of the sylveon flake!
      Please go away if you have not permitted access >:
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
    "ssh-gh" = {
      rekeyFile = "${self}/secrets/ssh-gh.age"; # Loading github ssh key
      mode = "644";
      group = "users";
    };
    "ssh-bb" = {
      rekeyFile = "${self}/secrets/ssh-bb.age"; # Loading github ssh key
      mode = "644";
      group = "users";
    };
  };
}