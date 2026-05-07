{
  self,
  config,
  inputs,
  ...
}:
let
  configSysDir = "${self}/systems/${config.networking.hostName}";
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  /*
    The default Agenix configuration, with the new age-rekey module
    The age.rekey.hostPubkey is located in the hosts default file
    All secret files can be found in the hosts folder ${hostname}/secrets/
  */
  config.age = {
    rekey = {
      hostPubkey = builtins.readFile (configSysDir + "/key.pub");
      masterIdentities = [ ./age-yubikey.pub ];

      # Secrets are located in the local repository
      storageMode = "local";
      localStorageDir = configSysDir + "/secrets";
    };

    generators = {
      # Generate a random string that is encrypted as sha256 after that
      sha256 = _: "echo tr -dc A-Za-z0-9 </dev/urandom | head -c 13 | sha256sum | cut -d ' ' -f1";
    };

    identityPaths = [
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
