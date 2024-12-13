{ inputs, system, config, ... }: {
  /*
  * Get the currents system directory
  */
  getSystemDirectory = 
    "${inputs.self}/systems/${system}/${config.networking.hostName}";

  getCurrentSecretDirectory =
    ./. + "/secrets/";
  
}
