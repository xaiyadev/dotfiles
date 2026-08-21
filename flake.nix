{
  description = "Xaiya's Configuration";

  outputs =
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./modules/flake ]; };

  inputs = {

    # main-repository
    # Also important note:
    # https://deer.social/profile/did:plc:mojgntlezho4qt7uvcfkdndg/post/3loogwsoqok2w
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # own package repository
    # using local version, so that I dont have to push every single change when testing
    # xaipkgs.url = "path:/home/xaiya/documents/development/nix-pkgs";
    xaipkgs = {
      type = "github";
      owner = "xaiyadev";
      repo = "nix-pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: other solution for storing this file in the path without adding it to nix?
    # The beta build of the musicpresence-software
    private-files = {
      url = "path:/home/xaiya/documents/packages";
      flake = false;
    };

    # declarative theme manager; The one I use the most currently !!
    catppuccin = {
      type = "github";
      owner = "catppuccin";
      repo = "nix";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secret manager based on age encryption
    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management,, extended with yubikeys !!
    agenix-rekey = {
      type = "github";
      owner = "oddlama";
      repo = "agenix-rekey";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake management tool, keeping all together nicely
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";

      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # easily manage our hosts devices
    easy-hosts = {
      type = "github";
      owner = "tgirlcloud";
      repo = "easy-hosts";
    };
  };
}
