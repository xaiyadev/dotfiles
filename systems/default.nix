{ inputs, ... }: {
 imports = [ inputs.easy-hosts.flakeModule ];

 config.easy-hosts = {
  autoConstruct = true;
  path = inputs.self.outPath + /systems;

  perClass = class: {
    modules = [
      "../modules/" # Import modules for each class
      "../modules/home" # # Import home configuration modules

      "../home" # Import users
    ];
  };

  hosts = {
    pineapple = { # Maybe change name
    };
  };
 };
}