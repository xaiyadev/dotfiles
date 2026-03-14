{ inputs, self, ... }:
{
  imports = [ inputs.easy-hosts.flakeModule ];

  config.easy-hosts = {
    perClass = class: {
      modules = [
        "${self}/modules/base"
        "${self}/modules/${class}"
        "${self}/home"
      ];
    };

    hosts = {
      # Framework laptop
      pineapple = { };

      # Home server
      apricot = { };

      # school system
      apple = { };
    };
  };
}
