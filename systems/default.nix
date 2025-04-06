{ inputs, self, ... }: {
 imports = [ inputs.easy-hosts.flakeModule ];

 config.easy-hosts = {
  perClass = class: {
    modules = [
      "${self}/modules/${class}/default.nix" # Import modules for each class
      "${self}/modules/home/default.nix" # # Import home configuration modules

      "${self}/home/default.nix" # Import users
    ];
  };

  hosts = {
    # Framework laptop
    pineapple = { };
  };
 };
}