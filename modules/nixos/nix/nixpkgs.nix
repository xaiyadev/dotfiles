{ inputs, ... }: {
  # TODO: evaluation warning (cant use nixpkgs.config when using home-manager.useGlobalPkgs)
  nixpkgs.config = {
    # Allowance of packages
    allowUnfree = true;
    allowBroken = false;

    allowUnfreePredicate = _: true;
    allowAliases = false;

    # Warn me if something has no maintainer anymore (sad >:)
    # Never mind, there are to many... for now!
    # showDerivationWarnings = [ "maintainerless" ];
  };

  nixpkgs.overlays = [
    (import ./overlays/mpv.nix)
    inputs.nix-jetbrains-plugins.overlays.default

    (final: prev: {
      enpass = prev.enpass.overrideAttrs {
        src = prev.fetchurl {
          url = "https://apt.enpass.io/pool/main/e/enpass/enpass_6.11.13.1957_amd64.deb";
          sha256 = "LYyQZDhRWRr/QQV7OAp+h7uDm/XFqgyhRWFE6ZlskCo=";
        };
      };
    })

  ];
}
