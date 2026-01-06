{
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org" # nix-community cache
      "https://ezkea.cachix.org" # AAGL caches
      "https://nix-gaming.cachix.org" # gaming packages
      "https://catppuccin.cachix.org" # a cache for all catppuccin ports
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };
}
