{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true; # always allow all packages

    # dont wanna get annoyed and confused with different package names
    # being the same thing
    allowAliases = false;

    allowUnsupportedSystem = false; # duh
    allowBroken = false;
  };
}
