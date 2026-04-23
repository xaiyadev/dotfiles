{ config, self, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  services.openssh = {
    enable = true;
    ports = [ 22 ];

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

    "ssh-tangled" = {
      # Tangled ssh key
      rekeyFile = "${self}/secrets/ssh-tangled.age";
      mode = "644";
      group = "users";
    };
  };
}
