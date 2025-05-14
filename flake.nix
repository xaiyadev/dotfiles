{
  description = "Xaiya's Configuration";

  outputs =
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } { imports = [ ./modules/flake ]; };

  inputs = {
    # Forked and better version of nix :>
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixpkgs-unstable";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Make passwords go puff
    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
    };

    # Make password go puff (with the help of keys)
    agenix-rekey = {
      type = "github";
      owner = "oddlama";
      repo = "agenix-rekey";
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

    stylix = {
      type = "github";
      owner = "danth";
      repo = "stylix";
    };

    tinted-theming-schemes = {
      type = "github";
      owner = "tinted-theming";
      repo = "schemes";
      flake = false;
    };

    nixcord = {
      type = "github";
      owner = "kaylorben";
      repo = "nixcord";
    };

    ulauncher = {
      type = "github";
      owner = "Ulauncher";
      repo = "Ulauncher";
      ref = "v6";
    };


  };

}
