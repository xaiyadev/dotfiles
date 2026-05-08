{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    # We want to use the stable lix releases
    package = pkgs.lixPackageSets.stable.lix;

    # we dont need channels, we use flakes
    channel.enable = false;

    settings = {
      experimental-feature = [
        "flakes"
        "nix-command" # needed for flakes
      ];

      log-lines = 50;
      warn-dirty = false;
      http-connections = 50;

      # We can ignore the flake registry since we won't be using it
      # this is because we already have all the programs we need in the ISO
      flake-registry = "";

      accept-flake-config = false;
      auto-optimise-store = false;

      substituters = [ ];
      trusted-public-keys = [ ];
    };
  };
}