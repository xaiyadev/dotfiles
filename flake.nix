{
  description = "Xaiya's Configuration";

  outputs =
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./modules/flake ]; };

  inputs = {

    # main-repository
    # Also important note:
    # https://deer.social/profile/did:plc:mojgntlezho4qt7uvcfkdndg/post/3loogwsoqok2w
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # Forked and better version of nix :>
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # declarative theme manager; The one I use the most currently !!
    catppuccin = {
      type = "github";
      owner = "catppuccin";
      repo = "nix";
    };

    # ATProtocol git platform
    tangled = {
      url = "git+https://tangled.org/@tangled.org/core";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: change once at hardware part of this configuration?
    # uses an entire repository with lots of configuration for just one (framework) module
    # could write it into an own module
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
      ref = "master";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secret manager based on age encryption
    # the original agenix is needed for agenix-rekey, so dont mind them two being there
    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secret manager based on age encryption
    # this adds security key and system based encryption support !!
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

    # Nix systems list
    # TODO: needed?
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };

    # TIDAL (music client)
    # injection for features like plugins and themes
    tidaLuna = {
      type = "github";
      owner = "Inrixia";
      repo = "TidaLuna";
    };

    # TODO: other solution?
    nixcord = {
      type = "github";
      owner = "KaylorBen";
      repo = "nixcord";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
