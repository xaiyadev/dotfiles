{ inputs, self, ... }: {
 imports = [ inputs.easy-hosts.flakeModule ];

 config.easy-hosts = {
  perClass = class: {
    modules = [ ];
  };

  hosts = {
    # Framework laptop
    pineapple = { };
  };
 };
}