{ inputs', ... }: {
  sylveon.packages = { 
    neovim =  inputs'.xaivim.packages.default; 
  };
}
