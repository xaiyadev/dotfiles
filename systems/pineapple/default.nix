{ self, ... }: {
  imports = [
    ./fileSystem.nix
  ];

  sylveon = {

    profiles = {
      graphical.enable = true;
      laptop.enable = true;
      gaming.enable = true;
    };

    users = [
      "xaiya"
      "blmedia"
    ];

    hardware = {
      cpu = "amd";
      gpu = "amd";

      yubikey.enable = true;
    };

    services.docker.enable = true;
  };
  
  #  TODO: find a spot to safe this
  age.secrets."multi-scrobbler-env" = {
    rekeyFile = "${self}/secrets/multi-scrobbler-env.age";
    group = "users";
    mode = "440";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
