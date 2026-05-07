{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    filterAttrs
    mapAttrs
    ;

  inherit (lib.types) isType;

  flakeInputs = filterAttrs (name: value: (isType "flake" value) && (name != "self")) inputs;
in
{
  # https://github.com/NixOS/nixpkgs/blob/eca4605163a534aed1981de0f5f1d7d7639d1640/nixos/modules/programs/environment.nix#L18
  environment.variables.NIXPKGS_CONFIG = lib.mkForce "";

  nix = {
    # We want to use the stable lix releases
    package = pkgs.lixPackageSets.stable.lix;

    # pin the registry to avoid downloading and evaluating a new nixpkgs version everytime
    registry = (mapAttrs (_: flake: { inherit flake; }) flakeInputs) // {
      # https://github.com/NixOS/nixpkgs/pull/388090
      nixpkgs = lib.mkForce { flake = inputs.nixpkgs; };
    };

    # Garbage collector,, yaay !!
    gc = {
      automatic = true;

      options = "--delete-older-than 3d";
      dates = "Mon *-*-* 03:00";
    };

    # No using of channels here !!
    channel.enable = false;

    settings = {
      # Sometimes had problems where I needed to switch to a live-environment to clean all up
      # this should fix this issue by saving up to 20GIB if there is less than 5GB left !!
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      # optimise symlinks in nix store
      auto-optimise-store = true;

      # all sudoers should be allowed to use nix
      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];

      # system decides max jobs
      max-jobs = "auto";

      # build first in a sandbox to keep the system safe
      sandbox = true;

      # even after breaking the derivations should be build !!
      keep-going = true;
      log-lines = 30;

      experimental-features = [
        "flakes"
        "nix-command" # needed for flakes

        # Allows nix to automatically pic UDs for builds
        "auto-allocate-uids"
      ];

      warn-dirty = false;

      # We dont want to run 3rd party flake configurations
      accept-flake-config = false;

      keep-derivations = true;
      keep-outputs = true;

      build-dir = "/var/tmp";

      # keep it xdg based
      use-xdg-base-directories = true;
    };

  };
}
