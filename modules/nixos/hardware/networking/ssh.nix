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
      rekeyFile = "${self}/secrets/ssh-gh.age";
      mode = "644";
      group = "users";
    };

    "ssh-bb" = {
      # Bitbucket
      rekeyFile = "${self}/secrets/ssh-bb.age";
      mode = "644";
      group = "users";
    };

    "ssh-gl-xy" = {
      # Xaiya's Gitlab
      rekeyFile = "${self}/secrets/ssh-gl-xy.age";
      mode = "644";
      group = "users";
    };

  };
}
