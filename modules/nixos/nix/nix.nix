{ self, config, pkgs, ... }:
let
  inherit (self.lib.users) filterTrustedUsers;

  trustedUsers = filterTrustedUsers config.sylveon.users config;
in
{
  nix = {
    package = pkgs.lix;

    settings = {
      # Free up space if system reaches 5GB
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      auto-optimise-store = true;


      # Keep building even after one derivation fails
      keep-going = true;

      # Remove annoying warnings...
      warn-dirty = false;

      # Let the system decide on its own, how many jobs should run
      max-jobs = "auto";

      # Important to disable because of vulnerability reasons
      accept-flake-config = false;

      # Allow users with root access to work with the nix daemon/store
      trusted-users = trustedUsers;
      allowed-users = trustedUsers;

      experimental-features = [
        # Enable Flakes
        "flakes"
        "nix-command"

        # Removes the unnecessary creations of users
        "auto-allocate-uids"
      ];
    };

    # Garbage collection.
    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };

  };
}
