{
  ...
}:
{
  imports = [
    ./fileSystem.nix
  ];

  sylveon = {
    hardware = {
      yubikey.enable = true;
    };

    system = {
      cpu = "amd";
      gpu = "amd";
    };
  };

}
