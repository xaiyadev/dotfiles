{
  nixpkgs.config = {
    # Allowance of packages
    allowUnfree = true;
    allowBroken = false;

    # Warn me if something has no maintainer anymore (sad >:)
    # Never mind, there are to many... for now!
    # showDerivationWarnings = [ "maintainerless" ];
  };
}