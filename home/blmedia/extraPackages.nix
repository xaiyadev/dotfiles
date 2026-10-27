{ inputs', ... }: {
  sylveon.packages = { 
    neovim = inputs'.xaivim.packages.default.override { withCord = false; };
  };
}
