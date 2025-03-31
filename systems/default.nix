{ inputs, self, ... }: {
 imports = [ inputs.easy-hosts.flakeModule ];

 config.easy-hosts = {
  autoConstruct = true;
  path = self + /systems;

  perClass = class: {
    modules = [
      "${self}/modules/${class}" # Import modules for each class
      "${self}/modules/home" # # Import home configuration modules

      "${self}/home" # Import users
    ];
  };

  hosts = {
    pineapple = { # Maybe change name
      
    };


  };
 };

}