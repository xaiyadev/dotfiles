{
  description = "Xaiya's Configuration";

  outputs =
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./modules/flake ]; };

  inputs = {

    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixpkgs-unstable";
    };

    # Forked and better version of nix :>
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-jetbrains-plugins = {
      type = "github";
      owner = "Janrupf";
      repo = "nix-jetbrains-plugin-repository";
    };

    catppuccin = {
      type = "github";
      owner = "catppuccin";
      repo = "nix";
    };

    # Tangled knots
    tangled = {
      url = "git+https://tangled.org/tangled.org/core";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Package collection
    tgirlpkgs = {
      type = "github";
      owner = "tgirlcloud";
      repo = "pkgs";
    };

    nixvim = {
      type = "github";
      owner = "nix-community";
      repo = "nixvim";
    };

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
    };

    # Make passwords go puff
    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Make password go puff (with the help of keys)
    agenix-rekey = {
      type = "github";
      owner = "oddlama";
      repo = "agenix-rekey";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # bring all the mess together with flake-parts
    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";

      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    easy-hosts = {
      type = "github";
      owner = "tgirlcloud";
      repo = "easy-hosts";
    };

    # Nix systems list
    systems = {
      type = "github";
      owner = "nix-systems";
      repo = "default";
    };

    # Injected TIDAL
    tidaLuna = {
      type = "github";
      owner = "Inrixia";
      repo = "TidaLuna";
    };

    tinted-theming-schemes = {
      type = "github";
      owner = "tinted-theming";
      repo = "schemes";
      flake = false;
    };

    nixcord = {
      type = "github";
      owner = "KaylorBen";
      repo = "nixcord";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      type = "github";
      owner = "fufexan";
      repo = "nix-gaming";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      type = "github";
      owner = "ezKEa";
      repo = "aagl-gtk-on-nix";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      type = "github";
      owner = "vicinaehq";
      repo = "vicinae";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
