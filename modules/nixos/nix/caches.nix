{
  nix.settings = {
    substituters = [
      "https://ezkea.cachix.org" # AAGL caches
    ];

    trusted-public-keys = [
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" # AAGL caches
    ];
  };
}
