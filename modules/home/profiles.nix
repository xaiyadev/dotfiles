{ osConfig, ... }:
{
  config = {
    sylveon.profiles = {
      inherit (osConfig.sylveon.profiles)
        graphical
        laptop
        server
        gaming
        ;
    };
  };
}
