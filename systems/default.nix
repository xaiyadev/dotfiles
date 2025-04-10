{ inputs, self, ... }: {
 imports = [ inputs.easy-hosts.flakeModule ];

 config.easy-hosts = {
  perClass = class: {
    modules = [
      "${self}/modules/${class}"
    ];
  };

  hosts = {
    # Framework laptop
    pineapple = { };
  };
 };
}