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

      cpu = "amd";
      gpu = "amd";
    };
  };

}
