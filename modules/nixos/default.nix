{
  imports = [
    ./hardware # hardware configuration (e.g gpu, cpu, networking, etc.)
    ./nix # specific configuration for the nix environment
    ./environment # environment variables and configurations (e.g fonts, time etc.)
    ./security # security thingies
    ./system # configuration for our system

    ./users.nix # load and create users
    ./extraPackages.nix # packages that need to be loaded but are not big enough to be an own module
  ];
}
