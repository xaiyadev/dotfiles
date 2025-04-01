{inputs, ...}: {

  imports = [
    "${inputs.self.outPath}/systems"
    #../../lib
  ];

  config = {
    debug = true;
  };
}
