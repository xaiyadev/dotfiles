{ inputs, self, ... }: {
 imports = [ inputs.easy-hosts.flakeModule ];

 config.easy-hosts = {
  perClass = class: {
    modules = [
      "${self}/modules/${class}"
      "${self}/modules/base"
    ];
  };

  hosts = {
    # Framework laptop
    pineapple = { };
  };
 };
}