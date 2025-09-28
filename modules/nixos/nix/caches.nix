{
  nix.settings = {
    substituters = [
      "https://ezkea.cachix.org" # AAGL caches
      "https://nix-gaming.cachix.org" # gaming packages
      "https://vicinae.cachix.org" # Vicinae
    ];

    trusted-public-keys = [
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" # AAGL caches
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" # gaming packages
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=" # Vicinae
    ];
  };
}
