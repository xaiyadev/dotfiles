{ inputs, self, ... }: {
 imports = [ inputs.easy-hosts.flakeModule ];

 config.easy-hosts = {
  perClass = class: {
    modules = [
      "${self}/modules/${class}"
      "${self}/modules/base"

      "${self}/home"
    ];
  };

  hosts = {
    # Framework laptop
    pineapple = { };
  };
 };
}